require 'spec_helper'

class DeterminerExample
  include TaxTribs::MappingCodeDeterminer
  def penalty_level; end
  def dispute_type; end
  def case_type; end
  def closure_case_type; end
end

RSpec.describe TaxTribs::MappingCodeDeterminer do
  subject { DeterminerExample.new }
  let(:penalty_level) { }
  let(:dispute_type) { }
  let(:case_type) { }
  let(:closure_case_type) { }

  before do
    allow(subject).to receive(:penalty_level).and_return(penalty_level)
    allow(subject).to receive(:dispute_type).and_return(dispute_type)
    allow(subject).to receive(:case_type).and_return(case_type)
    allow(subject).to receive(:closure_case_type).and_return(closure_case_type)
  end

  let(:case_attrs)          { {} }
  let(:challenged_decision) { nil }
  let(:case_type)           { nil }
  let(:closure_case_type)   { nil }
  let(:dispute_type)        { nil }
  let(:penalty_level)       { nil }

  # Stupid mutant wants to test the actual exception message. Just one test is enough.
  context 'when there is no case_type nor closure_case_type' do
    it { expect{ subject.mapping_code }.to raise_error('Unable to determine mapping code for tribunal_case') }
    it { expect(subject.valid_for_determining_mapping_code?).to eq(false) }
  end

  context 'when there is a penalty and it is level 1' do
    let(:penalty_level) { PenaltyLevel::PENALTY_LEVEL_1 }

    it { is_expected.to have_mapping_code(:appeal_penalty_low) }
    it { expect(subject.valid_for_determining_mapping_code?).to eq(true) }
  end

  context 'when there is a penalty and it is level 2' do
    let(:penalty_level) { PenaltyLevel::PENALTY_LEVEL_2 }

    it { is_expected.to have_mapping_code(:appeal_penalty_med) }
  end

  context 'when there is a penalty and it is level 3' do
    let(:penalty_level) { PenaltyLevel::PENALTY_LEVEL_3 }

    it { is_expected.to have_mapping_code(:appeal_penalty_high) }
  end

  context 'when there is a penalty but it is an unhandled value' do
    let(:penalty_level) { PenaltyLevel.new('$^&%*') }

    it { expect{ subject.mapping_code }.to raise_error(StandardError) }
  end

  context 'when the dispute is an appeal against a PAYE coding notice' do
    let(:dispute_type) { DisputeType::PAYE_CODING_NOTICE }

    it { is_expected.to have_mapping_code(:appeal_payecoding) }
  end

  context 'when the dispute is an appeal against an information notice' do
    let(:dispute_type) { DisputeType::INFORMATION_NOTICE }

    it { is_expected.to have_mapping_code(:appeal_infonotice) }
  end

  context 'when the dispute is about amount of tax owed by HMRC' do
    let(:dispute_type) { DisputeType::AMOUNT_OF_TAX_OWED_BY_HMRC }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about amount of tax owed by the taxpayer' do
    let(:dispute_type) { DisputeType::AMOUNT_OF_TAX_OWED_BY_TAXPAYER }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about amount of tax and a penalty' do
    let(:dispute_type) { DisputeType::AMOUNT_AND_PENALTY }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about something else' do
    let(:dispute_type) { DisputeType::OTHER }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about a refusal to register the application' do
    let(:dispute_type) { DisputeType::REFUSAL_TO_REGISTER_APPLICANT }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about a cancellation of registration' do
    let(:dispute_type) { DisputeType::CANCELLATION_OF_REGISTRATION }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about a security notice' do
    let(:dispute_type) { DisputeType::SECURITY_NOTICE }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about a registration issue' do
    let(:dispute_type) { DisputeType::REGISTRATION }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when the dispute is about penalty but there is no penalty amount' do
    let(:dispute_type) { DisputeType::PENALTY }

    it { expect{ subject.mapping_code }.to raise_error(StandardError) }
  end

  context 'when there is a dispute type but it is an unhandled value' do
    let(:dispute_type) { DisputeType.new(:anything_else) }

    it { expect{ subject.mapping_code }.to raise_error(StandardError) }
  end

  context 'when the case type is about something else' do
    let(:case_type) { CaseType::OTHER }

    it { is_expected.to have_mapping_code(:appeal_other) }
  end

  context 'when there is a case type but it is an unhandled value' do
    let(:case_type) { CaseType.new(:anything_else) }

    it { is_expected.to have_mapping_code(:appn_other) }
  end

  context 'when there is a closure case type' do
    let(:closure_case_type) { ClosureCaseType::PERSONAL_RETURN }

    it { is_expected.to have_mapping_code(:appn_decision_enqry) }
  end
end
