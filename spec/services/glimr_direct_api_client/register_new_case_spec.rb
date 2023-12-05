require 'spec_helper'

RSpec.describe GlimrDirectApiClient::RegisterNewCase do
  let(:params) { {} }
  let(:post_response) { double(status: 200, body: {}) }
  let(:rest_client) { double.as_null_object }
  let(:api) { described_class.new(params) }

  before do
    allow(ENV).to receive(:fetch).with('GLIMR_API_DEBUG', '').and_return('false')
  end

  describe '#endpoint' do
    specify {
      # Quick-n-dirty mutant kill.
      expect(described_class.new(params).send(:endpoint)).to eq('/registernewcase')
    }
  end

  context 'validating parameters' do
    let(:valid_params) { { jurisdictionId: 8, onlineMappingCode: 'something' } }

    it 'raises an error when no parameters are supplied' do
      expect { described_class.call }.to raise_error(ArgumentError)
    end

    context 'when onlineMappingCode is missing' do
      let(:params) { { jurisdictionId: 8 } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:onlineMappingCode]')
      end
    end

    context 'when jurisdictionId is missing' do
      let(:params) { { onlineMappingCode: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:jurisdictionId]')
      end
    end

    it 'does not raise an error when required parameters are provided' do
      expect(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      expect(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      expect(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      allow(ENV).to receive(:fetch).with('GLIMR_API_DEBUG', '').and_return('false')
      stub_request(:post, /glimr/).to_return(status: 200, body: {response: 'response'}.to_json)
      expect { described_class.call(valid_params) }.not_to raise_error
    end
  end

  describe '#re_raise_error' do
    let(:params) { { jurisdictionId: 8, onlineMappingCode: 'something' } }
    let(:body) { { message: '' } }

    before do
      expect(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      expect(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      expect(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      allow(ENV).to receive(:fetch).with('GLIMR_API_DEBUG', '').and_return('false')
      stub_request(:post, /glimr/).to_return(status: 200, body: body.to_json)
    end

    # are not processed here.
    context 'error 411 - Jurisdiction not found' do
      let(:body) { { glimrerrorcode: 411, message: 'Not found' } }

      it 'raises JurisdictionNotFound' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::RegisterNewCase::JurisdictionNotFound, 'Not found')
      end
    end

    context 'error 412 - Online Mapping not found' do
      let(:body) { { glimrerrorcode: 412, message: 'Not found' } }

      it 'raises OnlineMappingNotFoundOrInvalid' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::RegisterNewCase::OnlineMappingNotFoundOrInvalid, 'Not found')
      end
    end

    context 'error 421 - CaseCreationFailed' do
      let(:body) { { glimrerrorcode: 421, message: 'Failed' } }

      it 'raises CaseCreationFailed' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::RegisterNewCase::CaseCreationFailed, 'Failed')
      end
    end

    context 'unknown glimr error' do
      let(:body) { { glimrerrorcode: 5_000, message: 'Boom' } }

      it 'raises Unavailable with the error message' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::Unavailable, 'Boom')
      end
    end
  end
end
