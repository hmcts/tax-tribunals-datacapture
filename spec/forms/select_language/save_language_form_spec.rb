require 'spec_helper'

RSpec.describe SelectLanguage::SaveLanguageForm do

  let(:arguments) { {
    tribunal_case: tribunal_case,
    language: language,
    language_value: language_value
  } }
  let(:tribunal_case) { instance_double(TribunalCase) }
  let(:language) { 'english' }
  let(:language_value) { Language.new(language) }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'has the values for the Language value object' do
      expect(described_class.choices).to eq(Language.values.map(&:to_s))
    end
  end

  describe 'tribunal case' do
    context 'for a `nil` tribunal case' do
      let(:tribunal_case) { nil }

      it 'raises an error when calling save' do
        expect{subject.send(:persist!)}.to raise_error('No TribunalCase given')
      end
    end

    context 'when there is a tribunal case and the language has changed' do
      before do
        allow(subject).to receive(:changed?).and_return(true)
        allow(tribunal_case).to receive(:update).with(language: language_value)

      end

      it 'does not raise an error when calling save' do
        expect{subject.send(:persist!)}.to_not raise_error('No TribunalCase given')
      end

      it 'updates tribunal_case' do
        expect(tribunal_case).to receive(:update).with(language: language_value)
        subject.send(:persist!)
      end
    end
  end

  describe 'changed?' do
    context 'when tribunal_case language has changed' do
      before do
        allow(tribunal_case).to receive(:language).and_return('random_language')
      end

      it 'returns true' do
        expect(subject.send(:changed?)).to be(true)
      end
    end

    context 'when tribunal_case language has not changed' do
      before do
        allow(tribunal_case).to receive(:language).and_return(Language.new(language))
      end

      it 'returns false' do
        expect(subject.send(:changed?)).to be(false)
      end
    end
  end

  describe 'language validation' do
    before { subject.language = Language.new(language).to_s }

    context 'true for english' do
      let(:language) { :english }
      it { expect(subject).to be_valid }
    end

    context 'true for english_welsh' do
      let(:language) { :english_welsh }
      it { expect(subject).to be_valid }
    end

    context 'false for spanish' do
      let(:language) { :spanish }
      it { expect(subject).not_to be_valid }
    end
  end
end
