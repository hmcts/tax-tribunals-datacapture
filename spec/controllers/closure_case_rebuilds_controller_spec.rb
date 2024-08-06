
RSpec.describe ClosureCaseRebuildsController do
  subject(:closure_rebuild) { described_class.new }
  let(:tribunal_case) { TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'CLOSURE_ATTEMPT') }

  describe '#current_tribunal_case= and presenter' do
    before { closure_rebuild.current_tribunal_case = tribunal_case }
    it {
      expect(closure_rebuild.current_tribunal_case).to eq(tribunal_case)
      expect(closure_rebuild.presenter).to be_instance_of(CheckAnswers::ClosureAnswersPresenter)
    }
  end

  describe '#pdf_template' do
    it { expect(closure_rebuild.pdf_template).to eq 'steps/closure/check_answers/show' }
  end

  describe '#presenter_class' do
    it { expect(closure_rebuild.presenter_class).to eq CheckAnswers::ClosureAnswersPresenter }
  end
end
