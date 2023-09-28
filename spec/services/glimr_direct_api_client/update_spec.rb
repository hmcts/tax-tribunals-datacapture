require 'spec_helper'

RSpec.describe GlimrDirectApiClient::Update do
  let(:params) { {} }
  let(:post_response) { double(status: 200, body: {}) }
  let(:rest_client) { double.as_null_object }
  let(:api) { described_class.new(params) }

  describe '#endpoint' do
    specify {
      # Quick-n-dirty mutant kill.
      expect(described_class.new(params).send(:endpoint)).to eq('/paymenttaken')
    }
  end

  context 'validating parameters' do
    let(:valid_params) { { feeLiabilityId: '7', paymentReference: 'something', govpayReference: 'something', paidAmountInPence: 'something' } }

    it 'raises an error when no parameters are supplied' do
      expect { described_class.call }.to raise_error(ArgumentError)
    end

    context 'when feeLiabilityId is missing' do
      let(:params) { { paymentReference: 'something', govpayReference: 'something', paidAmountInPence: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:feeLiabilityId]')
      end
    end

    context 'when paymentReference is missing' do
      let(:params) { { feeLiabilityId: '7', govpayReference: 'something', paidAmountInPence: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:paymentReference]')
      end
    end

    context 'when govpayReference is missing' do
      let(:params) { { feeLiabilityId: '7', paymentReference: 'something', paidAmountInPence: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:govpayReference]')
      end
    end

    context 'when paidAmountInPence is missing' do
      let(:params) { { feeLiabilityId: '7', paymentReference: 'something', govpayReference: 'something' } }

      it 'raises an error' do
        expect { described_class.call(params) }.to raise_error(GlimrDirectApiClient::RequestError, '[:paidAmountInPence]')
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
    let(:params) { { feeLiabilityId: '7', paymentReference: 'something', govpayReference: 'something', paidAmountInPence: 'something' } }
    let(:body) { { message: '' } }

    before do
      allow(ENV).to receive(:fetch).with('GLIMR_API_URL').and_return('https://glimr-api-emulator.herokuapp.com/Live_API/api/tdsapi/')
      allow(ENV).to receive(:fetch).with('GLIMR_AUTHORIZATION_KEY', '').and_return('key')
      allow(ENV).to receive(:fetch).with('GLIMR_REGISTER_NEW_CASE_TIMEOUT_SECONDS', 32).and_return('32')
      stub_request(:post, /glimr/).to_return(status: 200, body: body.to_json)
    end

    # are not processed here.
    context 'error 311 - FeeLiability not found' do
      let(:body) { { glimrerrorcode: 311, message: 'Not found' } }

      it 'raises FeeLiabilityNotFound' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::Update::FeeLiabilityNotFound, 'Not found')
      end
    end

    context 'error 312 - PaymentReferenceInvalidFormat' do
      let(:body) { { glimrerrorcode: 312, message: 'Invalid format' } }

      it 'raises PaymentReferenceInvalidFormat' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::Update::PaymentReferenceInvalidFormat, 'Invalid format')
      end
    end

    context 'error 314 - GovPayReferenceInvalidFormat' do
      let(:body) { { glimrerrorcode: 314, message: 'Invalid format' } }

      it 'raises GovPayReferenceInvalidFormat' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::Update::GovPayReferenceInvalidFormat, 'Invalid format')
      end
    end

    context 'error 315 - InvalidAmount' do
      let(:body) { { glimrerrorcode: 315, message: 'Invalid amount' } }

      it 'raises InvalidAmount' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::Update::InvalidAmount, 'Invalid amount')
      end
    end

    context 'error 321 - GovPayReferenceExistsOnSystem' do
      let(:body) { { glimrerrorcode: 321, message: 'Reference exists' } }

      it 'raises GovPayReferenceExistsOnSystem' do
        expect {
          described_class.call(params)
        }.to raise_error(GlimrDirectApiClient::Update::GovPayReferenceExistsOnSystem, 'Reference exists')
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