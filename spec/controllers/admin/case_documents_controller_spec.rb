require 'rails_helper'

RSpec.describe Admin::CaseDocumentsController, type: :controller do
  let(:tribunal_case) { double('tc', files_collection_ref: 'TC/123') }
  let(:params) { { id: 'TC/123' } }
  let(:storage) { double('storage', generate_uri: '123_url') }
  let(:filepath_1) { 'deb757fc-f06d-4233-b260-11edcb7416f3/grounds_for_appeal/IAYP4244-Edit.jpg' }
  let(:filepath_2) { 'deb757fc-f06d-4233-b260-11edcb7416f3/grounds_for_appeal/IAYP4244-Edit2.jpg' }

  before do
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_ACCOUNT').and_return('123')
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_KEY').and_return('123')
    allow(ENV).to receive(:fetch).with('AZURE_STORAGE_CONTAINER').and_return('123')

    allow(TribunalCase).to receive(:find_by_files_collection_ref)
      .and_return(tribunal_case)
    allow(Azure::Storage::Common::Core::Auth::SharedAccessSignature).to \
      receive(:new).and_return(double)
    allow(Azure::Storage::Blob::BlobService).to \
      receive(:create).and_return(storage)
    allow_any_instance_of(Azure::Storage::Common::Core::Auth::SharedAccessSignature).to receive(:signed_uri).and_return(double(
                                                                                                                          'signed_uri', to_s: 'signed_url'
                                                                                                                        ))
    allow(Uploader).to \
      receive(:list_files).and_return([
        double('blob', name: filepath_1),
        double('blob', name: filepath_2)
      ])
  end

  describe '#show' do
    context 'correct credentials' do
      let(:user) { FactoryBot.create(:user, admin: true) }
      before do
        sign_in user
      end

      it 'returns http success' do
        local_get(:show, params:)
        expect(response).to have_http_status(:success)
      end

      it 'gets a list of available files' do
        local_get(:show, params:)

        expect(assigns(:files)).to match([
          Uploader::File.new(filepath_1),
          Uploader::File.new(filepath_2)
        ])
      end
    end

    context 'missing credentials' do
      it 'requires sign in' do
        local_get(:show, params:)
        expect(response).to redirect_to(new_user_session_path(locale: I18n.locale))
      end
    end

    context 'wrong credentials' do
      let(:user) { FactoryBot.create(:user) }
      before do
        sign_in user
      end

      it 'returns http unauthorized' do
        local_get(:show, params:)
        expect(response).to redirect_to(new_user_session_path(locale: I18n.locale))
      end
    end
  end
end
