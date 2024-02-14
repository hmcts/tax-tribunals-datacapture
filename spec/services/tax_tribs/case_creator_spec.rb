require 'spec_helper'

RSpec.describe TaxTribs::CaseCreator do
  let!(:tribunal_case) { TribunalCase.create }
  let(:current_time) { Time.zone.now }

  subject { described_class.new(tribunal_case) }

  describe '.new' do
    it 'accepts a tribunal case' do
      expect(subject.tribunal_case).to eq(tribunal_case)
    end
  end

  describe '#call' do
    before do
      allow(TaxTribs::GlimrNewCase).to receive(:new).with(tribunal_case).and_return(glimr_new_case_double)
      Timecop.freeze(current_time)
    end

    after { Timecop.return }

    context 'registering the case into glimr' do
      context 'marking the tribunal case as `submit_in_progress`' do
        let(:glimr_new_case_double) {
          instance_double(TaxTribs::GlimrNewCase, call: double(case_reference: 'TC/2017/12345', confirmation_code: 'ABCDEF'))
        }

        it 'should mark the tribunal case as `submit_in_progress` while GLiMR call is executed' do
          expect(tribunal_case).to receive(:update).with(case_status: CaseStatus::SUBMIT_IN_PROGRESS)
          expect(tribunal_case).to receive(:update).with(
            case_reference: 'TC/2017/12345', case_status: CaseStatus::SUBMITTED,
            submitted_at: current_time
          )
          subject.call
        end
      end

      context 'when glimr call was success' do
        let(:glimr_new_case_double) {
          instance_double(TaxTribs::GlimrNewCase, call: double(case_reference: 'TC/2017/12345', confirmation_code: 'ABCDEF'))
        }

        it 'should store the case reference in the DB entry' do
          subject.call
          expect(tribunal_case.case_reference).to eq('TC/2017/12345')
        end

        it 'should mark the case as `submitted`' do
          subject.call
          expect(tribunal_case.case_status).to eq(CaseStatus::SUBMITTED)
        end
      end

      context 'when glimr call fails' do
        let(:glimr_new_case_double) {
          instance_double(TaxTribs::GlimrNewCase, call: double(case_reference: nil, confirmation_code: nil))
        }

        it 'should remain with a nil case reference in the DB entry' do
          subject.call
          expect(tribunal_case.case_reference).to be_nil
        end

        it 'should mark the case as `submitted` regardless' do
          subject.call
          expect(tribunal_case.case_status).to eq(CaseStatus::SUBMITTED)
          expect(tribunal_case.submitted_at).to eq(current_time)
        end
      end
    end
  end
end
