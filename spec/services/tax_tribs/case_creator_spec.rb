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
      Timecop.freeze(current_time)
      allow(GlimrApiCallJob).to receive(:perform_later)
    end

    after { Timecop.return }

    context 'successful glimr call' do
      it 'should mark the tribunal case as `submitted`' do
        expect(tribunal_case).to receive(:update).with(
          case_status: CaseStatus::SUBMITTED,
          submitted_at: current_time
        )
        subject.call
      end

      it 'should enqueue glimr api call job' do
        expect(GlimrApiCallJob).to receive(:perform_later).with(tribunal_case)
        subject.call
      end
    end

    context 'unsuccessful glimr call' do
      it 'should mark the tribunal case as `submitted`' do
        expect(tribunal_case).to receive(:update).with(
          case_status: CaseStatus::SUBMITTED,
          submitted_at: current_time
        )
        subject.call
      end
    end
  end
end
