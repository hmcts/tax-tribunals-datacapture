require 'spec_helper'

RSpec.describe GlimrDirectApiClient::PayByAccount do
  let(:params) { {} }
  let(:post_response) { double(status: 200, body: {}) }
  let(:rest_client) { double.as_null_object }
  let(:api) { described_class.new(params) }

  describe '#endpoint' do
    specify {
      # Quick-n-dirty mutant kill.
      expect(described_class.new(params).send(:endpoint)).to eq('/pbapaymentrequest')
    }
  end

  context 'validating parameters' do
    let(:valid_params) {
 { feeLiabilityId: '7', pbaAccountNumber: 'something', pbaConfirmationCode: 'something', pbaTransactionReference: 'something' } }

    it 'raises an error when no parameters are supplied' do
      expect { described_class.call }.to raise_error(ArgumentError)
    end

    context 'when feeLiabilityId is missing' do
      let(:params) { { pbaAccountNumber: 'something', pbaConfirmationCode: 'something', pbaTransactionReference: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:feeLiabilityId]')
      end
    end

    context 'when pbaAccountNumber is missing' do
      let(:params) { { feeLiabilityId: '7', pbaConfirmationCode: 'something', pbaTransactionReference: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:pbaAccountNumber]')
      end
    end

    context 'when pbaConfirmationCode is missing' do
      let(:params) { { feeLiabilityId: '7', pbaAccountNumber: 'something', pbaTransactionReference: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:pbaConfirmationCode]')
      end
    end

    context 'when pbaTransactionReference is missing' do
      let(:params) { { feeLiabilityId: '7', pbaAccountNumber: 'something', pbaConfirmationCode: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:pbaTransactionReference]')
      end
    end

    context 'when pbaTransactionReference is too long' do
      let(:params) { { feeLiabilityId: '7', pbaAccountNumber: 'something', pbaConfirmationCode: 'something',
                       pbaTransactionReference: (0...241).map { 'a' }.join.to_s } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:pbaTransactionReferenceTooLong]')
      end
    end

    it 'does not raise an error when required parameters are provided' do
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      allow(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      allow(ENV).to receive(:fetch).with('GLIMR_API_DEBUG', '').and_return('false')
      stub_request(:post, /glimr/).to_return(status: 200, body: {response: 'response'}.to_json)
      expect { described_class.call(valid_params) }.not_to raise_error
    end
  end

  describe '#re_raise_error' do
    let(:params) {
 { feeLiabilityId: '7', pbaAccountNumber: 'something', pbaConfirmationCode: 'something', pbaTransactionReference: 'something' } }
    let(:body) { { message: '' } }

    before do
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      allow(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      allow(ENV).to receive(:fetch).with('GLIMR_API_DEBUG', '').and_return('false')
      stub_request(:post, /glimr/).to_return(status: 200, body: body.to_json)
    end

    # are not processed here.
    context 'error 511 - Fee Liability not found' do
      let(:body) { { glimrerrorcode: 511, message: 'Not found' } }

      it 'raises FeeLiabilityNotFound' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::PayByAccount::FeeLiabilityNotFound, 'Not found')
      end
    end

    context 'error 512 - AccountNotFound not found' do
      let(:body) { { glimrerrorcode: 512, message: 'Not found' } }

      it 'raises AccountNotFound' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::PayByAccount::AccountNotFound, 'Not found')
      end
    end

    context 'error 513 - InvalidAccountAndConfirmation not found' do
      let(:body) { { glimrerrorcode: 513, message: 'Not found' } }

      it 'raises InvalidAccountAndConfirmation' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::PayByAccount::InvalidAccountAndConfirmation, 'Not found')
      end
    end

    context 'error 514 - InvalidAmount' do
      let(:body) { { glimrerrorcode: 514, message: 'Invalid AmountToPay' } }

      it 'raises InvalidAmount' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::PayByAccount::InvalidAmount, 'Invalid AmountToPay')
      end
    end

    context 'error 521 - GlobalStatusInactive' do
      let(:body) { { glimrerrorcode: 521, message: 'Status Inactive' } }

      it 'raises GlobalStatusInactive' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::PayByAccount::GlobalStatusInactive, 'Status Inactive')
      end
    end

    context 'error 522 - JurisdictionStatusInactive' do
      let(:body) { { glimrerrorcode: 522, message: 'Status Inactive' } }

      it 'raises JurisdictionStatusInactive' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::PayByAccount::JurisdictionStatusInactive, 'Status Inactive')
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