require 'rails_helper'

RSpec.describe GlimrApiCallJob, type: :job do
  let!(:tribunal_case) { TribunalCase.create }
  let(:current_time) { Time.zone.now }

  describe '#perform' do
    before do
      allow(TaxTribs::GlimrNewCase).to receive(:new).with(tribunal_case).and_return(glimr_new_case_double)
    end

    context 'when glimr call was success' do
      let(:glimr_new_case_double) {
        instance_double(TaxTribs::GlimrNewCase, call: double(case_reference: 'TC/2017/12345', confirmation_code: 'ABCDEF'))
      }

      before do
        GlimrApiCallJob.perform_now(tribunal_case)
      end

      it 'calls GlimrNewCase.call' do
        expect(glimr_new_case_double).to have_received(:call)
      end

      it 'should store the case reference in the DB entry' do
        expect(tribunal_case.case_reference).to eq('TC/2017/12345')
      end

    end

    context 'when glimr call fails' do
      let(:glimr_new_case_double) {
        instance_double(TaxTribs::GlimrNewCase, call: double(case_reference: nil, confirmation_code: nil))
      }

      before do
        GlimrApiCallJob.perform_now(tribunal_case)
      end

      it 'should remain with a nil case reference in the DB entry' do
        expect(tribunal_case.case_reference).to be_nil
      end
  end
  end
end


