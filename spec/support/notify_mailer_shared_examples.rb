require 'rails_helper'

RSpec.shared_examples 'a Notify mail' do |options|
  let(:template_id) { options.fetch(:template_id) }

  it 'is a govuk_notify delivery' do
    expect(mail.delivery_method).to be_a(GovukNotifyRails::Delivery)
  end

  it 'sets the template' do
    expect(mail.govuk_notify_template).to eq(template_id)
  end

  # This is just internal, as the real subject gets set in the template at Notify website
  it 'sets the subject' do
    expect(mail.body).to match("This is a GOV.UK Notify email with template #{template_id}")
  end
end

RSpec.shared_examples 'sends the correct text message' do |language, template_id|
  let(:phone_number) { '07777777777' }
  let(:case_reference) { 'TC/2017/00001' }
  let(:personalisation) do
    {
      appeal_or_application: :appeal,
      submission_date_and_time: '1 January 2017 12:00hrs',
      case_reference: case_reference
    }
  end

  it "sends the text for #{language}" do
    tribunal_case.language = Language.new(language)

    expect(tribunal_case).to receive(:send)
                               .with(:taxpayer_contact_phone)
                               .and_return(phone_number)

    expect_any_instance_of(Notifications::Client).to receive(:send_sms).with(
      phone_number: phone_number,
      template_id: template_id,
      reference: case_reference,
      personalisation: personalisation
    )

    NotifyMailer.new.application_details_text(tribunal_case, :taxpayer, "text content")
  end
end
