require 'spec_helper'

RSpec.describe ChallengeDecisionTree, '#destination' do
  let(:next_step)     { nil }
  let(:step_params)   { {challenged_decision_status: 'anything'} }
  let(:case_type)     { nil }
  let(:tribunal_case) {
    instance_double(
      TribunalCase,
      challenged_decision_status:,
      case_type:
    )
  }

  subject { described_class.new(tribunal_case:, step_params:, next_step:) }

  context 'when the step is `challenged_decision_status`' do
    context 'and the status is a late appeal/review' do
      let(:case_type) {CaseType.new(:anything)}

      context '`appeal_late_rejection`' do
        let(:challenged_decision_status) {ChallengedDecisionStatus::APPEAL_LATE_REJECTION}
        it {is_expected.to have_destination('/steps/lateness/in_time', :edit)}
      end

      context '`review_late_rejection`' do
        let(:challenged_decision_status) {ChallengedDecisionStatus::REVIEW_LATE_REJECTION}
        it {is_expected.to have_destination('/steps/lateness/in_time', :edit)}
      end
    end

    context 'and the status is `pending`' do
      let(:challenged_decision_status) { ChallengedDecisionStatus::PENDING }

      context 'for a direct tax case' do
        let(:case_type) { CaseType.new(:anything, direct_tax: true) }

        it { is_expected.to have_destination(:must_wait_for_challenge_decision, :show) }
      end

      context 'for an indirect tax case' do
        let(:case_type) { CaseType.new(:anything, direct_tax: false) }

        it { is_expected.to have_destination(:must_wait_for_review_decision, :show) }
      end
    end

    context 'and the status is other than `pending`' do
      let(:challenged_decision_status) { ChallengedDecisionStatus::RECEIVED }

      context 'for a case with disputes' do
        let(:case_type) { CaseType.new(:anything, ask_dispute_type: true, ask_penalty: false) }

        it { is_expected.to have_destination('/steps/appeal/dispute_type', :edit) }
      end

      context 'for a case with penalties' do
        let(:case_type) { CaseType.new(:anything, ask_dispute_type: false, ask_penalty: true) }

        it { is_expected.to have_destination('/steps/appeal/penalty_amount', :edit) }
      end

      context 'for a case that has neither penalties or disputes' do
        let(:case_type) { CaseType.new(:anything, ask_dispute_type: false, ask_penalty: false) }

        it { is_expected.to have_destination('/steps/lateness/in_time', :edit) }
      end
    end
  end
end
