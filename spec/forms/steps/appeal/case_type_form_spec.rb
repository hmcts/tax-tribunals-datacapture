require 'spec_helper'

RSpec.describe Steps::Appeal::CaseTypeForm do
  let(:arguments) { {
    tribunal_case:,
    case_type:,
    case_type_not_present:,
    case_type_other_value:
  } }
  let(:tribunal_case) { instance_double(TribunalCase, case_type: nil) }
  let(:case_type) { nil }
  let(:case_type_not_present) { nil }
  let(:case_type_other_value) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        income_tax
        self_assessment_late_penalty
        vat
        capital_gains_tax
        corporation_tax
      ))
    end
  end

  describe '.dropdown_choices' do
    it 'returns the relevant choices' do
      expect(described_class.dropdown_choices).to eq(%w(
        apn_penalty aggregates_levy air_passenger_duty
        alcoholic_liquor_duties bingo_duty climate_change_levy
        construction_industry_scheme counter_terrorism customs_duty
        dotas_penalty export_regulations_penalty gaming_duty
        general_betting_duty hydrocarbon_oil_duties information_notice
        inheritance_tax insurance_premium_tax landfill_tax lottery_duty
        money_laundering_decisions ni_contributions petroleum_revenue_tax
        pool_betting_duty remote_gaming_duty restoration_case stamp_duties
        statutory_payments student_loans tax_credits tobacco_products_duty
      ))
    end
  end

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:case_type)     { 'vat' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when case_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case_type is not valid' do
      let(:case_type) { 'lave-linge-pas-cher' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case_type is valid' do
      let(:case_type) { 'income_tax' }
      let(:case_type_object) { instance_double(CaseType) }

      it 'saves the record' do
        allow(CaseType).to receive(:find_constant).with('income_tax').and_return(case_type_object)
        expect(tribunal_case).to receive(:update).with(
          case_type: case_type_object,
          case_type_other_value: nil,
          challenged_decision: nil,
          challenged_decision_status: nil,
          dispute_type: nil,
          dispute_type_other_value: nil,
          penalty_level: nil,
          penalty_amount: nil,
          tax_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when case_type is nil but other value is entered' do
      let(:case_type) { nil }
      let(:case_type_object) { instance_double(CaseType) }
      let(:case_type_not_present) { true }
      let(:case_type_other_value) { 'some other value' }

      it 'saves the record with case type of other and other description' do
        allow(CaseType).to receive(:find_constant).with('other').and_return(case_type_object)
        expect(tribunal_case).to receive(:update).with(
          case_type: case_type_object,
          case_type_other_value: 'some other value',
          challenged_decision: nil,
          challenged_decision_status: nil,
          dispute_type: nil,
          dispute_type_other_value: nil,
          penalty_level: nil,
          penalty_amount: nil,
          tax_amount: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
