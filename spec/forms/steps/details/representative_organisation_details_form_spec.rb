require 'spec_helper'

RSpec.describe Steps::Details::RepresentativeOrganisationDetailsForm do
  it_behaves_like 'a contactable entity form',
    entity_type: :representative,
    additional_fields: [
      :representative_organisation_name,
      :representative_organisation_fao
    ]

  it_behaves_like 'a validated phone number', entity_type: :representative,
    additional_fields: [
      :representative_organisation_name,
      :representative_organisation_fao
    ]

  describe '#name_fields' do
    specify { expect(subject.name_fields).to eq([:representative_organisation_name]) }
  end

  describe '#show_fao?' do
    specify { expect(subject.show_fao?).to eq(true) }
  end

  describe '#show_registration_number?' do
    specify { expect(subject.show_registration_number?).to eq(false) }
  end
end
