require 'rails_helper'

RSpec.describe Admin::GlimrGenerationController, type: :controller do
  before do
    allow(ENV).to receive(:fetch).with('GLIMR_API_URL',
                                       'https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi').and_return(
                                         'http://glimr'
                                       )
    allow(ENV).to receive(:fetch).with('GLIMR_DIRECT_API_URL',
                                       'https://glimr-api.taxtribunals.dsd.io/Live_API/api/tdsapi').and_return(
                                         'http://glimr'
                                       )
    allow(ENV).to receive(:fetch).with('GLIMR_DIRECT_ENABLED', 'false').and_return(true)
    allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return(32)
  end

  describe '#new' do
    it_behaves_like 'a password-protected admin controller', :new
  end

  describe '#create' do
    it_behaves_like 'a password-protected admin controller', :create

    context 'correct credentials' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'test')
      end

    context 'with valid number of records and parameters' do

      before do
        sign_in double('employee')
        allow(Admin::GenerateGlimrRecordJob).to receive(:perform_in)

        batch_double = instance_double("Sidekiq::Batch")
        allow(Sidekiq::Batch).to receive(:new).and_return(batch_double)
        allow(batch_double).to receive(:description=)
        allow(batch_double).to receive(:on)
        allow(batch_double).to receive(:jobs).and_yield

        @callback_double = double('Admin::GenerateGlimrRecordsComplete')
        allow(Admin::GenerateGlimrRecordsComplete).to receive(:new).and_return(@callback_double)
        allow(@callback_double).to receive(:call)
      end

      let(:valid_params) do
        {
          'number-of-records': '2',
          onlineMappingCode: '12345',
          contactFirstName: 'Jane',
          contactLastName: 'Doe',
          contactPreference: 'email',
          email: 'jane.doe@example.com'
        }
      end

      it 'queues the creation of records and sets a flash notice' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('success')
        expect(response).to render_template(:new)
        expect(Admin::GenerateGlimrRecordJob).to have_received(:perform_in).exactly(2).times
      end

      it 'correctly processes generator parameters' do
        post :create, params: valid_params
        expect(assigns(:payload)).to include({
          jurisdictionId: 8,
          "onlineMappingCode" => '12345',
          "contactFirstName" => 'Jane',
          "contactLastName" => 'Doe',
          "contactPreference" => 'email'
        })
      end
    end

    context 'with invalid number of records' do
      before { sign_in double('employee') }
      it 'renders the new template with errors' do
        post :create, params: { 'number-of-records': '0' }
        expect(assigns(:errors)).to include(:number_of_records)
        expect(response).to render_template(:new)
      end
    end

      # it 'creates a batch of jobs' do
      #   receive_count = 0
      #   allow_any_instance_of(Admin::GenerateGlimrRecordJob).to \
      #     receive(:perform) { receive_count += 1 }
      #   stub_request(:any, "http://glimr/registernewcase").to_return(body: {"abc":"def"}.to_json)

      #   Sidekiq::Testing.inline! do
      #     local_post :create, params: {
      #       'number-of-records': 3,
      #       contactFirstName: 'Joe',
      #       contactLastName: 'Bloggs',
      #       contactPreference: 'email',
      #       email: 'test@example.com'
      #     }
      #   end
      #   expect(receive_count).to eq 3
      # end
    end
  end
end
