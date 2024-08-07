require 'spec_helper'

RSpec.describe Uploader::File do
  let(:filepath) { 'deb757fc-f06d-4233-b260-11edcb7416f3/grounds_for_appeal/letter.jpg' }

  let(:container) { '123' }
  let(:storage_account_name) { '123' }

  before do
    allow(Azure::Storage::Blob::BlobService).to receive(:create).and_return(
      double('client', generate_uri: 'www.example.com')
    )
    Settings.azure.storage_container = container
    Settings.azure.storage_account_name = storage_account_name

    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_KEY').and_return('123')
  end

  it 'gets a signed url' do
    expect_any_instance_of(Azure::Storage::Common::Core::Auth::SharedAccessSignature).to receive(:signed_uri).and_return(double(
                                                                                                                           'signed_uri', to_s: 'signed_url'
                                                                                                                         ))
    file = described_class.new(filepath)
    expect(file.url).to eq 'signed_url'
  end

  it 'gets the display name' do
    file = described_class.new(filepath)
    expect(file.name).to eq 'grounds_for_appeal/letter.jpg'
  end
end