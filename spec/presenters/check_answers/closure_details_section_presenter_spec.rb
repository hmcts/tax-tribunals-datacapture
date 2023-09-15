require 'spec_helper'

module CheckAnswers
  describe ClosureDetailsSectionPresenter do
    subject { described_class.new(tribunal_case) }
    let(:tribunal_case) { TribunalCase.new }

    let(:answer) { instance_double(Answer, show?: true) }
    let(:documents_submitted_answer) { instance_double(DocumentsSubmittedAnswer, show?: true) }
    let(:file_or_text_answer) { instance_double(FileOrTextAnswer, show?: true) }
    let(:multi_answer) { instance_double(MultiAnswer, show?: true) }

    before do
      allow(tribunal_case).to receive(:documents).and_return([])

      allow(Answer).to receive(:new).and_return(answer)
      allow(MultiAnswer).to receive(:new).and_return(multi_answer)
      allow(DocumentsSubmittedAnswer).to receive(:new).and_return(documents_submitted_answer)
      allow(FileOrTextAnswer).to receive(:new).and_return(file_or_text_answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:closure_details)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(subject.answers.count).to eq(7)

        expect(subject.answers[0]).to eq(answer)
        expect(subject.answers[1]).to eq(answer)
        expect(subject.answers[2]).to eq(answer)
        expect(subject.answers[3]).to eq(answer)
        expect(subject.answers[4]).to eq(file_or_text_answer)
        expect(subject.answers[5]).to eq(documents_submitted_answer)
        expect(subject.answers[6]).to eq(answer)
      end
    end

    describe '#support_answers' do
      it 'returns an array of support answers when need_support is YES' do

        tribunal_case = TribunalCase.new(need_support: NeedSupport::YES.to_s)
        presenter = described_class.new(tribunal_case)

        support_answers = presenter.send(:support_answers)

        expect(support_answers.count).to eq(2)

        expect(support_answers[0]).to eq(answer)
        expect(support_answers[1]).to eq(multi_answer)
      end

      it 'returns nil when need_support is not YES' do
        tribunal_case = TribunalCase.new(need_support: NeedSupport::NO.to_s)
        presenter = described_class.new(tribunal_case)

        support_answers = presenter.send(:support_answers)

        expect(support_answers).to be_nil
      end
    end
  end
end
