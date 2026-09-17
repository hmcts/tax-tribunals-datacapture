require_relative '../../services/glimr_direct_api_client'

class Admin::GenerateGlimrRecordJob
  include Sidekiq::Job

  def perform(payload)
    logger.info "Creating GLiMR Records with args #{payload.symbolize_keys}" if Rails.env.production?
    res = GlimrDirectApiClient::RegisterNewCase.call(payload.symbolize_keys)
    logger.info res.response_body

    raise Admin::GlimrError, "No response provided" unless res.response_body
    Sentry.capture_exception(Admin::GlimrError) unless res.response_body
  end
end
