require 'spec_helper'

RSpec.describe Steps::Details::TaxpayerTypeForm do
  let(:arguments) { {
    tribunal_case:,
    taxpayer_type:
  } }
  let(:tribunal_case) { instance_double(TribunalCase, taxpayer_type: nil) }
  let(:taxpayer_type) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }
      let(:taxpayer_type) { 'company' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(RuntimeError)
      end
    end

    context 'when taxpayer_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:taxpayer_type]).to_not be_empty
      end
    end

    context 'when taxpayer_type is not valid' do
      let(:taxpayer_type) { 'frustrated_from_essex' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:taxpayer_type]).to_not be_empty
      end
    end

    context 'when taxpayer_type is valid' do
      let(:taxpayer_type) { 'individual' }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(
          taxpayer_type: ContactableEntityType::INDIVIDUAL,
          taxpayer_individual_first_name: nil,
          taxpayer_individual_last_name: nil,
          taxpayer_organisation_name: nil,
          taxpayer_organisation_registration_number: nil,
          taxpayer_organisation_fao: nil,
          taxpayer_contact_address: nil,
          taxpayer_contact_postcode: nil,
          taxpayer_contact_city: nil,
          taxpayer_contact_country: nil,
          taxpayer_contact_email: nil,
          taxpayer_contact_phone: nil
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when in_time is already the same on the model' do
      let(:tribunal_case) {
        instance_double(
          TribunalCase,
          taxpayer_type: ContactableEntityType.new(:individual)
        )
      }
      let(:taxpayer_type) { 'individual' }

      it 'does not save the record but returns true' do
        expect(tribunal_case).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end

