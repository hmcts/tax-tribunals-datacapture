
RSpec.describe AppealCaseRebuildsController do
  subject(:appeal_rebuild) { described_class.new }
  let(:tribunal_case) { TribunalCase.create(case_reference: 'TC/2016/12345', pdf_generation_status: 'APPEAL_ATTEMPT') }

  describe '#current_tribunal_case= and presenter' do
    before { appeal_rebuild.current_tribunal_case = tribunal_case }
    it {
      expect(appeal_rebuild.current_tribunal_case).to eq(tribunal_case)
      expect(appeal_rebuild.presenter).to be_instance_of(CheckAnswers::AppealAnswersPresenter)
    }
  end

  describe '#pdf_template' do
    it { expect(appeal_rebuild.pdf_template).to eq 'steps/details/check_answers/show' }
  end

  describe '#presenter_class' do
    it { expect(appeal_rebuild.presenter_class).to eq CheckAnswers::AppealAnswersPresenter }
  end
end
