require 'spec_helper'

RSpec.describe TaxTribs::RebuildPdf do

  describe 'CaseDetailsPdf call' do
    context "with AppealCaseRebuildsController object not just class" do
      let(:tribunal_case) { TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'APPEAL_ATTEMPT') }
      let(:appeal_case_controller_object) { instance_double(AppealCaseRebuildsController) }
      let(:presenter_class) { CheckAnswers::AppealAnswersPresenter }
      let(:case_detail_pdf) { instance_double(TaxTribs::CaseDetailsPdf, generate_and_upload: true) }

      context "it has the correct parameters for appeal" do
        before do
          tribunal_case
          allow(TaxTribs::CaseDetailsPdf).to receive(:new).and_return case_detail_pdf
          allow(Sentry).to receive(:capture_message)
          allow(AppealCaseRebuildsController).to receive(:new).and_return appeal_case_controller_object
          allow(appeal_case_controller_object).to receive(:presenter).and_return presenter_class
          allow(appeal_case_controller_object).to receive(:request=)
          allow(appeal_case_controller_object).to receive(:current_tribunal_case=)
          described_class.rebuild
        end

        it 'pass correct attributes' do
          expect(Sentry).not_to have_received(:capture_message)
          expect(appeal_case_controller_object).to have_received(:request=)
          expect(appeal_case_controller_object).to have_received(:current_tribunal_case=).with(tribunal_case)
          expect(appeal_case_controller_object).to have_received(:presenter)
          expect(TaxTribs::CaseDetailsPdf).to have_received(:new).with(tribunal_case, appeal_case_controller_object, presenter_class)
        end

        after do
          tribunal_case.destroy
        end
      end
    end

    context "with ClosureCasesController object not just class" do
      let(:tc) { TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'CLOSURE_ATTEMPT') }
      let(:closure_case_controller_object) { instance_double(ClosureCasesController) }
      let(:presenter_class) { CheckAnswers::ClosureAnswersPresenter }
      let(:case_detail_pdf) { instance_double(TaxTribs::CaseDetailsPdf, generate_and_upload: true) }

      context "it has the correct parameters for appeal" do
        before do
          tc
          allow(TaxTribs::CaseDetailsPdf).to receive(:new).and_return case_detail_pdf
          allow(Sentry).to receive(:capture_message)
          allow(ClosureCasesController).to receive(:new).and_return closure_case_controller_object
          allow(closure_case_controller_object).to receive(:presenter_class).and_return presenter_class
          described_class.rebuild
        end

        it 'pass correct attributes' do
          expect(Sentry).not_to have_received(:capture_message)
          expect(closure_case_controller_object).to have_received(:presenter_class)
          expect(TaxTribs::CaseDetailsPdf).to have_received(:new).with(tc, closure_case_controller_object, presenter_class)
        end

        after do
          tc.destroy
        end
      end
    end

    context "with incorrect pdf_generation_status" do
      let(:tc) { TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'Incorrect') }
      let(:appeal_case_controller_object) { instance_double(AppealCaseRebuildsController) }
      let(:presenter_class) { CheckAnswers::AppealAnswersPresenter }
      let(:case_detail_pdf) { instance_double(TaxTribs::CaseDetailsPdf, generate_and_upload: true) }

      context "it has the correct parameters for appeal" do
        before do
          tc
          allow(TaxTribs::CaseDetailsPdf).to receive(:new).and_return case_detail_pdf
          allow(Sentry).to receive(:capture_message)
          allow(AppealCaseRebuildsController).to receive(:new).and_return appeal_case_controller_object
          allow(appeal_case_controller_object).to receive(:presenter_class).and_return presenter_class
          described_class.rebuild
        end

        it 'records the error on sentry' do
          expect(Sentry).to have_received(:capture_message)
          expect(appeal_case_controller_object).not_to have_received(:presenter_class)
          expect(TaxTribs::CaseDetailsPdf).not_to have_received(:new)
        end

        after do
          tc.destroy
        end
      end
    end
  end
end
