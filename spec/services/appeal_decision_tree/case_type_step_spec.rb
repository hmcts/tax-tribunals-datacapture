require 'spec_helper'

RSpec.describe AppealDecisionTree, '#destination' do
  let(:tribunal_case)     {
 instance_double(TribunalCase, case_type:, case_type_other_value:, user_id:, navigation_stack:, language:) }
  let(:step_params)           { {case_type: 'anything'} }
  let(:next_step)             { nil }
  let(:case_type)             { nil }
  let(:case_type_other_value) { nil }
  let(:user_id)               { nil }
  let(:as)                    { :language }
  let(:navigation_stack)      { [] }
  let(:language)              { 'en' }

  subject { described_class.new(tribunal_case:, step_params:, next_step:, as:) }

  context 'for a case asking asking `challenged question`' do
    let(:case_type) { CaseType.new(:dummy, ask_challenged: true) }
    it { is_expected.to have_destination('/steps/challenge/decision', :edit) }
  end

  context 'for a case not asking `challenged question`' do
    context 'when the case type is one that should ask dispute type' do
      let(:case_type) { CaseType.new(:dummy, ask_challenged: false, ask_dispute_type: true) }

      it { is_expected.to have_destination('/steps/appeal/dispute_type', :edit) }
    end

    context 'when the case type is one that should only ask penalty' do
      let(:case_type) { CaseType.new(:dummy, ask_challenged: false, ask_dispute_type: false, ask_penalty: true) }

      it { is_expected.to have_destination('/steps/appeal/penalty_amount', :edit) }
    end
  end

  context 'when the case type is TAX_CREDITS' do
    let(:case_type) { CaseType::TAX_CREDITS }
    it { is_expected.to have_destination('/steps/appeal/tax_credits_kickout', :show) }
  end

  context 'when the case type is OTHER' do
    let(:case_type) { CaseType::OTHER }
    it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
  end

  context 'save_and_return' do
    let(:user_id)   { nil }
    let(:as)        { nil }

    context 'case_type has a value' do
      let(:case_type) { CaseType.new(:dummy, ask_challenged: false, ask_dispute_type: true) }
      let(:step_params) {{ case_type: 'vat' }}

      it { is_expected.to have_destination('/steps/appeal/case_type_details', :edit) }
    end
  end
end
