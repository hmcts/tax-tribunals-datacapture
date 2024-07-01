require 'spec_helper'

RSpec.describe Admin::RestoreImagesJob, type: :job do
  let(:client) { instance_double('Azure::Storage::Blob::BlobService', get_blob: ['', 'U2VuZCByZWluZm9yY2VtZW50cw==\n'] ) }
  let(:uploader) { instance_double('DocumentUpload', valid?: valid_uploader, upload!: true, errors?: false, errors: nil) }
  let(:valid_uploader) { true }

  describe '#perform' do
    before {
      allow(Azure::Storage::Blob::BlobService).to receive(:create).and_return client
      allow(DocumentUpload).to receive(:new).and_return uploader
    }

    context 'client' do
      it 'create blob' do
        described_class.new.perform('this is name')
        expect(Azure::Storage::Blob::BlobService).to have_received(:create)
      end
    end

    context 'tempfile' do
      it 'create' do
        allow(Tempfile).to receive(:create).with('tmpfile')
        described_class.new.perform('this is name')
        expect(Tempfile).to have_received(:create)
      end

      it 'bin write' do
        allow(File).to receive(:binwrite)
        described_class.new.perform('this is name')
        expect(File).to have_received(:binwrite)
      end
    end

    context 'uplader' do
      it 'uploads right file' do
        described_class.new.perform('this is name')
        expect(uploader).to have_received(:upload!)
      end

      it 'uploads' do
        described_class.new.perform('this is name')
        expect(uploader).to have_received(:upload!)
      end

      context 'not valid' do
        let(:valid_uploader) { false }
        it 'no uploads' do
          described_class.new.perform('this is name')
          expect(uploader).not_to have_received(:upload!)
        end
      end

      context 'errors' do
        let(:uploader) { instance_double('DocumentUpload', valid?: valid_uploader, upload!: true, errors?: true, errors: 'uploader error') }
        it 'no uploads' do
          expect{described_class.new.perform('this is name')}.to raise_error(Admin::RestoreImagesJob::UploadError, 'uploader error')
        end
      end
    end
  end

  describe '#storage_access_key' do
    before { allow(Settings.azure).to receive(:new_storage_key).and_return('test') }

    it 'env check' do
      allow(Settings.environment).to receive(:name)
      described_class.new.storage_access_key
      expect(Settings.environment).to have_received(:name)
    end

    it 'demo setting' do
      allow(Settings.environment).to receive(:name).and_return('demo')
      key = described_class.new.storage_access_key
      expect(key).to eql('test')
    end

    it 'other envs setting' do
      allow(Settings.environment).to receive(:name).and_return('test')
      key = described_class.new.storage_access_key
      expect(key).to eql('uvooxJ9DnBGw4E+Ebg0KVG5hCBcaLVE9gG9DQVGXLopDs6dG/ZrVrbN1RQM5DHu+8J24cbWY43JMrN5Ppo/fcQ==')
    end
  end
end
