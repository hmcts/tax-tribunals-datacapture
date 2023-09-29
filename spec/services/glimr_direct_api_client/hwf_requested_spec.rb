require 'spec_helper'

RSpec.describe GlimrDirectApiClient::HwfRequested do
  let(:params) { {} }
  let(:api) { described_class.new(params) }
  let(:post_response) { double(status: 200, body: {}) }
  let(:rest_client) { double.as_null_object }

  describe '#endpoint' do
    specify {
      # Quick-n-dirty mutant kill.
      expect(described_class.new(params).send(:endpoint)).to eq('/hwfrequested')
    }
  end

  context 'validating parameters' do
    let(:valid_params) { { feeLiabilityId: '7', hwfRequestReference: 'something' } }

    it 'raises an error when no parameters are supplied' do
      expect { described_class.call }.to raise_error(ArgumentError)
    end

    context 'when hwfRequestReference is missing' do
      let(:params) { { feeLiabilityId: '7' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:hwfRequestReference]')
      end
    end

    context 'when jurisdictionId is missing' do
      let(:params) { { hwfRequestReference: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:feeLiabilityId]')
      end
    end

    it 'does not raise an error when required parameters are provided' do
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      allow(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      stub_request(:post, /glimr/).to_return(status: 200, body: {response: 'response'}.to_json)
      expect { described_class.call(valid_params) }.not_to raise_error
    end
  end

  describe '#re_raise_error' do
    let(:params) { { feeLiabilityId: '7', hwfRequestReference: 'something' } }
    let(:body) { { message: '' } }

    before do
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      allow(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      stub_request(:post, /glimr/).to_return(status: 200, body: body.to_json)
    end

    # are not processed here.
    context 'error 611 - FeeLiability not found' do
      let(:body) { { glimrerrorcode: 611, message: 'Not found' } }

      it 'raises FeeLiabilityNotFound' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::HwfRequested::FeeLiabilityNotFound, 'Not found')
      end
    end

    context 'error 612 - InvalidAmount' do
      let(:body) { { glimrerrorcode: 612, message: 'Invalid AmountToPay' } }

      it 'raises InvalidAmount' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::HwfRequested::InvalidAmount, 'Invalid AmountToPay')
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
