RSpec.shared_examples 'a contactable entity form' do |params|
  entity_type = params.fetch(:entity_type)
  additional_fields = params.fetch(:additional_fields, [])
  optional_fields = params.fetch(:optional_fields, [])

  default_fields = [
    "#{entity_type}_contact_address",
    "#{entity_type}_contact_postcode",
    "#{entity_type}_contact_city",
    "#{entity_type}_contact_country",
    "#{entity_type}_contact_email",
    "#{entity_type}_contact_phone"
  ].map(&:to_sym)

  optional_fields += [
    "#{entity_type}_contact_phone"
  ].map(&:to_sym)

  fields = default_fields + additional_fields + optional_fields
  required_fields = fields - optional_fields

  let(:fields_with_dummy_values) { fields.to_h {|k|
      if k =~ /email/
        [k, 'foo@email.com']
      elsif k =~ /phone/
        [k, '07772622355']
      else
        [k, 'dummy_value']
      end
  } }
  let(:arguments) { fields_with_dummy_values.merge({ tribunal_case: tribunal_case }) }
  let(:tribunal_case) { instance_double(TribunalCase).as_null_object }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no tribunal_case is associated with the form' do
      let(:tribunal_case)  { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_exception
      end
    end

    required_fields.each do |field|
      context "when #{field} is not present" do
        let(:fields_with_dummy_values) { super().merge(field => nil) }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[field]).to_not be_empty
        end
      end
    end

    # default_fields.without("#{entity_type}_feedback_consent".to_sym).each do |field|
    default_fields.each do |field|
      context "when #{field} contains spaces" do
        let(:fields_with_dummy_values) { super().merge(field => '  dummy value  ') }

        it 'should trim the field' do
          value = subject.send(field)
          expect(value).to eq('dummy value')
        end
      end
    end

    context 'when the details are valid' do
      let(:fields_with_dummy_values) { super().merge(:"#{entity_type}_contact_email" => 'a@b.com') }

      it 'saves the record' do
        expect(tribunal_case).to receive(:update).with(fields_with_dummy_values).and_return(true)
        expect(subject.save).to be(true)
      end
    end
  end
end
