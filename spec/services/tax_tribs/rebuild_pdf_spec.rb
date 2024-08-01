require 'spec_helper'

RSpec.describe TaxTribs::RebuildPdf do
  %w[APPEAL_ATTEMPT
     APPEAL_FAILED
     CLOSURE_ATTEMPT
     CLOSURE_FAILED].each do |type|
    context "for an #{type}" do
      before(:each) do
        expect(TaxTribs::CaseDetailsPdf).to receive_message_chain(:new, :generate_and_upload)
        @tc = TribunalCase.create(case_reference: 'TC/2016/12345',
                                  pdf_generation_status: type)
      end

      after do
        @tc.destroy
      end

      it 're-attempts generation and upload' do
        described_class.rebuild
      end
    end
  end

  context "when no outstanding tribunal cases" do
    before(:each) do
      expect(TaxTribs::CaseDetailsPdf).not_to receive(:new)
      @tc = TribunalCase.create(case_reference: 'TC/2016/12345')
    end

    after do
      @tc.destroy
    end

    it 'does not re-attempt generation and upload' do
      described_class.rebuild
    end
  end

  context "when it raises a standard error" do
    before do
      @tc = TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'test')
      allow(TaxTribs::RebuildPdf).to receive(:build).with(@tc).and_raise(StandardError)
      expect(TaxTribs::CaseDetailsPdf).not_to receive(:new)
      expect(Sentry).to receive(:capture_message)
    end

    after do
      @tc.destroy
    end

    it 'does not re-attempt generation and upload' do
      described_class.rebuild
    end
  end
end
