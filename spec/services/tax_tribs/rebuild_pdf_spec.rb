require 'spec_helper'

RSpec.describe TaxTribs::RebuildPdf do
  # %w[APPEAL_ATTEMPT
  #    APPEAL_FAILED
  #    CLOSURE_ATTEMPT
  #    CLOSURE_FAILED].each do |type|
  #   context "for an #{type}" do
  #     before(:each) do
  #       expect(TaxTribs::CaseDetailsPdf).to receive_message_chain(:new, :generate_and_upload)
  #       @tc = TribunalCase.create(case_reference: 'TC/2016/12345',
  #                                 pdf_generation_status: type)
  #     end

  #     after do
  #       @tc.destroy
  #     end

  #     it 're-attempts generation and upload' do
  #       described_class.rebuild
  #     end

  #   end
  # end

  # context "when no outstanding tribunal cases" do
  #   before(:each) do
  #     expect(TaxTribs::CaseDetailsPdf).not_to receive(:new)
  #     @tc = TribunalCase.create(case_reference: 'TC/2016/12345')
  #   end

  #   after do
  #     @tc.destroy
  #   end

  #   it 'does not re-attempt generation and upload' do
  #     described_class.rebuild
  #   end
  # end

  # context "when it raises a standard error" do
  #   before do
  #     @tc = TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'test')
  #     allow(TaxTribs::RebuildPdf).to receive(:build).with(@tc).and_raise(StandardError)
  #     expect(TaxTribs::CaseDetailsPdf).not_to receive(:new)
  #     expect(Sentry).to receive(:capture_message)
  #   end

  #   after do
  #     @tc.destroy
  #   end

  #   it 'does not re-attempt generation and upload' do
  #     described_class.rebuild
  #   end
  # end

  # context "when everything is correct" do
  #   context "it has the correct parameters for appeal" do
  #     before do
  #       @tc = TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'APPEAL_ATTEMPT')
  #       expect(TaxTribs::CaseDetailsPdf).to receive(:new).with(@tc, AppealCasesController, CheckAnswers::AppealAnswersPresenter)
  #     end

  #     after do
  #       @tc.destroy
  #     end

  #     it 'does not re-attempt generation and upload' do
  #       described_class.rebuild
  #     end
  #   end

  #   context "it has the correct parameters for closure" do
  #     before do
  #       @tc = TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'CLOSURE_ATTEMPT')
  #       expect(TaxTribs::CaseDetailsPdf).to receive(:new).with(@tc, ClosureCasesController, CheckAnswers::ClosureAnswersPresenter)
  #     end

  #     after do
  #       @tc.destroy
  #     end

  #     it 'does not re-attempt generation and upload' do
  #       described_class.rebuild
  #     end
  #   end
  # end

  describe 'CaseDetailsPdf call' do
    context "with AppealCasesController object not just class" do
      let(:tc) { TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'APPEAL_ATTEMPT') }
      let(:appeal_case_controller_object) { instance_double(AppealCasesController) }
      let(:presenter_class) { CheckAnswers::AppealAnswersPresenter }
      let(:case_deatail_pdf) { instance_double(TaxTribs::CaseDetailsPdf, generate_and_upload: true) }

      context "it has the correct parameters for appeal" do
        before do
          tc
          allow(TaxTribs::CaseDetailsPdf).to receive(:new).and_return case_deatail_pdf
          allow(Sentry).to receive(:capture_message)
          allow(AppealCasesController).to receive(:new).and_return appeal_case_controller_object
          allow(appeal_case_controller_object).to receive(:presenter_class).and_return presenter_class
          described_class.rebuild
        end

        it 'pass correct attributes' do
          expect(Sentry).not_to have_received(:capture_message)
          expect(appeal_case_controller_object).to have_received(:presenter_class)
        end

        after do
          tc.destroy
        end
      end
    end

    context "with ClosureCasesController object not just class" do
      let(:tc) { TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'CLOSURE_ATTEMPT') }
      let(:closure_case_controller_object) { instance_double(ClosureCasesController) }
      let(:presenter_class) { CheckAnswers::ClosureAnswersPresenter }
      let(:case_deatail_pdf) { instance_double(TaxTribs::CaseDetailsPdf, generate_and_upload: true) }

      context "it has the correct parameters for appeal" do
        before do
          tc
          allow(TaxTribs::CaseDetailsPdf).to receive(:new).and_return case_deatail_pdf
          allow(Sentry).to receive(:capture_message)
          allow(ClosureCasesController).to receive(:new).and_return closure_case_controller_object
          allow(closure_case_controller_object).to receive(:presenter_class).and_return presenter_class
          described_class.rebuild
        end

        it 'pass correct attributes' do
          expect(Sentry).not_to have_received(:capture_message)
          expect(closure_case_controller_object).to have_received(:presenter_class)
        end

        after do
          tc.destroy
        end
      end
    end
  end

end
