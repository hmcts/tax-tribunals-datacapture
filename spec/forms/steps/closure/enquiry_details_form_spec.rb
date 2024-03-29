require 'spec_helper'

RSpec.describe Steps::Closure::EnquiryDetailsForm do
  let(:arguments) { {
    tribunal_case:,
    closure_hmrc_reference:,
    closure_hmrc_officer:,
    closure_years_under_enquiry:
  } }

  let(:tribunal_case) { instance_double(TribunalCase,
                                        closure_hmrc_reference:,
                                        closure_hmrc_officer:,
                                        closure_years_under_enquiry:) }
  let(:closure_hmrc_reference) { nil }
  let(:closure_hmrc_officer) { nil }
  let(:closure_years_under_enquiry) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case) { nil }
      let(:closure_hmrc_reference) { 'hmrc reference' }
      let(:closure_years_under_enquiry) { '3' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    it { should validate_presence_of(:closure_hmrc_reference) }
    it { should validate_presence_of(:closure_years_under_enquiry) }
    it { should_not validate_presence_of(:closure_hmrc_officer) }

    context 'when enquiry details are valid' do
      let(:closure_hmrc_reference) { 'hmrc reference' }
      let(:closure_hmrc_officer) { 'hmrc officer' }
      let(:closure_years_under_enquiry) { '3' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          closure_hmrc_reference: 'hmrc reference',
          closure_hmrc_officer: 'hmrc officer',
          closure_years_under_enquiry: '3'
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when closure_years_under_enquiry is not an integer' do
      let(:closure_hmrc_reference) { 'hmrc reference' }
      let(:closure_hmrc_officer) { 'hmrc officer' }
      let(:closure_years_under_enquiry) { 'test' }

      it 'is invalid' do
        expect(subject).not_to be_valid
      end
    end

    context 'when closure_years_under_enquiry is not in range 0-20' do
      let(:closure_hmrc_reference) { 'hmrc reference' }
      let(:closure_hmrc_officer) { 'hmrc officer' }
      let(:closure_years_under_enquiry) { '21' }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors).to include(:closure_years_under_enquiry)
      end
    end
  end
end
