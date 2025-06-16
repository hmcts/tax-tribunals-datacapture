require 'rails_helper'

RSpec.describe GlimrApiCallJob, type: :job do
  let!(:tribunal_case) { TribunalCase.create id: "8efbbd3f-67ca-4db8-aef1-29d8690928f5" }
  let(:current_time) { Time.zone.now }

  describe '#perform' do

    context 'when glimr call was success' do

      let(:glimr_new_case_double) {
        instance_double(TaxTribs::GlimrNewCase, call: double(case_reference: 'TC/2017/12345', confirmation_code: 'ABCDEF'))
      }

      before do
        allow(TaxTribs::GlimrNewCase).to receive(:new).with(tribunal_case).and_return(glimr_new_case_double)
        allow(Sentry).to receive(:capture_message)
        GlimrApiCallJob.perform_now(tribunal_case.id)
      end

      it 'calls GlimrNewCase.call' do
        expect(glimr_new_case_double).to have_received(:call)
      end

      it 'should store the case reference in the DB entry' do
        expect(tribunal_case.reload.case_reference).to eq('TC/2017/12345')
        expect(Sentry).to have_received(:capture_message).with("GLIMR call updated true for 8efbbd3f-67ca-4db8-aef1-29d8690928f5.", {level: :info})
      end
    end

    context 'when glimr call fails' do
      let(:glimr_new_case_double) {
        instance_double(TaxTribs::GlimrNewCase, call: nil)
      }

      before do
        allow(TaxTribs::GlimrNewCase).to receive(:new).with(tribunal_case).and_return(glimr_new_case_double)
        allow(Sentry).to receive(:capture_exception)
      end

      it 'throws a NoMethodError and Sentry captures exception' do
        expect {
          GlimrApiCallJob.perform_now(tribunal_case.id)
        }.to raise_error(NoMethodError)
        expect(Sentry).to have_received(:capture_exception).with(instance_of(NoMethodError), extra: { tribunal_case_id: tribunal_case.id })
      end
    end
  end
end


