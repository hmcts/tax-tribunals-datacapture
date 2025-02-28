require 'rails_helper'

RSpec.describe Steps::Appeal::CaseTypeDetailsController, type: :controller do
  let(:existing_case) { TribunalCase.create(case_status: nil) }

  let(:case_type) { nil }
  let(:language) { nil }

  before do
    allow(controller).to receive(:current_tribunal_case).and_return(existing_case)
    allow(existing_case).to receive(:case_type).and_return(case_type)
    allow(existing_case).to receive(:language).and_return(language)
  end

  describe '#edit' do
    it 'renders the expected page' do
      local_get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do

    context 'when language is nil' do
      let(:language) { nil }

      it 'redirects to language page' do
        put :update, params: {locale: :en}
        expect(controller).to redirect_to("/en/steps/select_language")
      end
    end

    context 'when language is present' do
      let(:language) { :en }

      context 'and case type is tax credits' do
        let(:case_type) { CaseType::TAX_CREDITS }

        it 'redirects to tax credits kickout page' do
          put :update, params: {locale: :en}
          expect(controller).to redirect_to("/en/steps/appeal/tax_credits_kickout")
        end
      end

      context 'and case type is an asked challenge' do
        let(:case_type) { CaseType::APN_PENALTY }

        it 'redirects to challenge page' do
          put :update, params: {locale: :en}
          expect(controller).to redirect_to("/en/steps/challenge/decision")
        end
      end

      context 'and case type is an ask dispute type' do
        let(:case_type) { instance_double("CaseType", ask_challenged?: false, ask_dispute_type?: true) }

        it 'redirects to dispute type page' do
          put :update, params: {locale: :en}
          expect(controller).to redirect_to("/en/steps/appeal/dispute_type")
        end
      end

      context 'and case type is an ask penalty type' do
        let(:case_type) { instance_double("CaseType", ask_challenged?: false, ask_dispute_type?: false, ask_penalty?: true) }


        before do
          allow(existing_case.case_type).to receive(:ask_challenged?).and_return(false)
        end
        it 'redirects to penalty amount page' do
          put :update, params: {locale: :en}
          expect(controller).to redirect_to("/en/steps/appeal/penalty_amount")
        end
      end

      context 'and case type is none of the above' do
        let(:case_type) { CaseType::OTHER }

        it 'redirects to penalty amount page' do
          put :update, params: {locale: :en}
          expect(controller).to redirect_to("/en/steps/lateness/in_time")
        end
      end
    end
  end
end
