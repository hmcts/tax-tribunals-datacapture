module Steps::Hardship
  class HardshipContactHmrcController < Steps::HardshipStepController
    CONTACT_HMRC_URL = "https://www.gov.uk/hmrc-internal-manuals/appeals-reviews-and-tribunals-guidance".freeze

    def edit; end

    def update
      redirect_to CONTACT_HMRC_URL, allow_other_host: true
    end
  end
end
