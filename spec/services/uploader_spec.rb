require 'spec_helper'

RSpec.describe Uploader do
  let(:container) { 'container' }
  let(:storage_account_name) { 'test' }
  let(:storage_access_key) { 'alU+HyX8m8djx4QaCTN3p3QRkTJz+DRKl8+z2BEq+KrYAPm6XhQT/iPPs1WgIgylYS2nn+qDkbqcstHn0A7Xsw==' }

  before do
    Settings.azure.storage_container = container
    Settings.azure.storage_account_name = storage_account_name

    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_KEY').and_return(storage_access_key)
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_DO_NOT_SCAN').and_return('test')
    allow_any_instance_of(Azure::Storage::Blob::BlobService)
      .to receive(:create_block_blob).and_return('blob-confirmation')
    allow_any_instance_of(described_class::AddFile).to receive(:sleep).and_return(nil)
  end

  describe '.add_file' do
    let(:params) { {
      collection_ref: '123',
      document_key: 'folder',
      filename: 'file_name.doc',
      data: 'data'
    } }

    it 'calls BlobService.create_block_blob' do
      expect_any_instance_of(
        Azure::Storage::Blob::BlobService
      ).to receive(
        :create_block_blob
      ).with(
        container, # container_name
        '123/folder/file_name.doc', # blob_name
        'data', # file_data
        { content_type: 'application/msword' }
      ).and_return('result')

      expect(described_class.add_file(**params)).to eq('result')
    end

    context 'storage key loading' do
      let(:client) { instance_double('Azure::Storage::Blob::BlobService', create_block_blob: true) }
      before do
        allow(Azure::Storage::Blob::BlobService).to receive(:create).and_return client
      end

      it 'demo key' do
        allow(Settings.environment).to receive(:name).and_return 'demo'
        allow(Settings.azure).to receive(:new_storage_key).and_return 'demo key'
        described_class.add_file(**params)
        credentials = { storage_access_key: 'demo key', storage_account_name: "test" }
        expect(Azure::Storage::Blob::BlobService).to have_received(:create).with(credentials)
      end

      it 'old key' do
        allow(Settings.environment).to receive(:name).and_return 'not demo'
        allow(Settings.azure).to receive(:new_storage_key).and_return 'demo key'
        described_class.add_file(**params)
        credentials = { storage_access_key: storage_access_key, storage_account_name: "test" }
        expect(Azure::Storage::Blob::BlobService).to have_received(:create).with(credentials)
      end
    end


    it 'raises Uploader::UploaderError if the contenttype is not recognised' do
      expect {
        described_class.add_file(
          collection_ref: '123',
          document_key: 'folder',
          filename: 'file_name.nonexistant',
          data: 'data'
        )}.to raise_error(Uploader::UploaderError)
    end

    it 'sanitizes file names' do
      expect_any_instance_of(
        Azure::Storage::Blob::BlobService
      ).to receive(
        :create_block_blob
      ).with(
        container, # container_name
        '123/folder/filenamedroptable.doc', # blob_name
        'data', # file_data
        { content_type: 'application/msword' }
      ).and_return('result')

      described_class.add_file(**params,
        filename: 'filename;drop table;.doc')
    end

    # TODO update the method to raise an error when missing env
    # it 'raises KeyError if the env var is missing' do
    #   allow(ENV).to receive(:fetch).with('AZURE_STORAGE_ACCOUNT').and_raise(KeyError)
    #   expect {
    #     described_class.add_file(**params)
    #   }.to raise_error(KeyError)
    # end

    it 'raises Uploader::UploaderError if the upload api call fails' do
      allow_any_instance_of(
        Azure::Storage::Blob::BlobService
      ).to receive(
        :create_block_blob
      ).and_raise(Faraday::TimeoutError)
      expect {
        described_class.add_file(**params)
      }.to raise_error(Uploader::UploaderError)
    end

    it 'raises Uploader::UploaderError if filename missing' do
      expect {
        described_class.add_file(**params, filename: nil)
      }.to raise_error(Uploader::UploaderError, "Filename must be provided")
    end

    it 'raises Uploader::UploaderError if file data missing' do
      expect {
        described_class.add_file(**params, data: nil)
      }.to raise_error(Uploader::UploaderError, "File data must be provided")
    end

    it 'if it receives Uploader::UploaderError, it retries the error a ' \
       'configurable number of times before re-raising' do
      allow_any_instance_of(described_class).to receive(:sleep)
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:create_block_blob)
        .exactly(described_class::AddFile::UPLOAD_RETRIES + 2).and_raise(StandardError)

      expect { described_class.add_file(**params) }.to raise_error(Uploader::UploaderError)
    end

    it 'retries are separated one second longer between each' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:create_block_blob)
        .at_least(described_class::AddFile::UPLOAD_RETRIES).times.and_raise(StandardError)

      expect_any_instance_of(described_class::AddFile).to receive(:sleep).once.with(0)
      expect_any_instance_of(described_class::AddFile).to receive(:sleep).once.with(1)
      expect_any_instance_of(described_class::AddFile).to receive(:sleep).once.with(2)

      expect { described_class.add_file(**params) }.to raise_error(Uploader::UploaderError)
    end

    context 'when filename is a Notice of Appeal' do
      let(:filename) { 'TC_2022_000753_hulk_hogan.pdf' }
      it 'keeps the notice of appeal when upload fails and is abandoned' do
        expect_any_instance_of(Azure::Storage::Blob::BlobService)
          .to receive(:create_block_blob)
          .at_least(described_class::AddFile::UPLOAD_RETRIES).times.and_raise(StandardError)

        expect(BackupNoa).to receive(:keep_noa).with(
          collection_ref: params[:collection_ref],
          folder: params[:document_key].to_s,
          filename:,
          data: params[:data]
        )
        expect { described_class.add_file(**params, filename:) }
          .not_to raise_error(Uploader::UploaderError)
      end
    end
  end

  describe '.list_files' do
    let(:params) { {
      collection_ref: '123',
      document_key: :doc_key
    } }

    it 'calls out to MojFileUploaderApiClient with the document key embedded in the collection ref' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:list_blobs).with(
          container,
          prefix: '123/doc_key/'
        ).and_return(['file', 'file_2'])

      expect(described_class.list_files(**params)).to eq(['file', 'file_2'])
    end

    it 'returns an empty array if no files found' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:list_blobs).with(
          container,
          prefix: '123/doc_key/'
        ).and_return([])

      expect(described_class.list_files(**params)).to eq([])
    end

    it 'raises Uploader::UploaderError if the uploader raises its own RequestError' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:list_blobs).with(
          container,
          prefix: '123/doc_key/'
        ).and_raise(StandardError)

      expect { described_class.list_files(**params) }.to raise_error(Uploader::UploaderError)
    end
  end

  describe '.delete_file' do
    let(:params) { {
      collection_ref: '123',
      document_key: :folder,
      filename: 'file_name.doc'
    } }

    it 'calls out to MojFileUploaderApiClient with the document key embedded in the filename' do
      expect_any_instance_of(
        Azure::Storage::Blob::BlobService
      ).to receive(:delete_blob).with(
        container,
        '123/folder/file_name.doc', # blob_name
      )
        .and_return('result')

      expect(described_class.delete_file(**params)).to eq('result')
    end

    it 'raises Uploader::UploaderError if the uploader raises its own RequestError' do
      expect_any_instance_of(
        Azure::Storage::Blob::BlobService
      ).to receive(:delete_blob).with(
        container,
        '123/folder/file_name.doc', # blob_name
      )
        .and_raise(StandardError)

      expect { described_class.delete_file(**params) }.to raise_error(
        Uploader::UploaderError
      )
    end
  end
end




