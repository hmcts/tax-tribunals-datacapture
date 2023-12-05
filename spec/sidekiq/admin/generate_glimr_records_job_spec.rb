require 'spec_helper'

RSpec.describe Admin::GenerateGlimrRecordJob, type: :job do
  let(:payload) { { record1: 'something', record2: 'something' } }

  describe '#perform' do
    before do
      allow(GlimrDirectApiClient::RegisterNewCase).to receive(:call).and_return(double(response_body: response))
    end

    context 'when GlimrDirectApiClient::RegisterNewCase.call fails' do
      let(:response) { nil }

      it 'raises a GlimrError' do
        expect { Admin::GenerateGlimrRecordJob.new.perform(payload) }.to raise_error(GlimrError, "No response provided")
      end
    end

    context 'when GlimrDirectApiClient::RegisterNewCase.call succeeds' do
      let(:response) { 'Response data' }

      it 'raises no error' do
        expect { Admin::GenerateGlimrRecordJob.new.perform(payload) }.not_to raise_error
      end
    end
  end
end
