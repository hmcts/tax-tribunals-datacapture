require_relative '../../services/glimr_direct_api_client'

class GlimrError < StandardError
end

class Admin::GenerateGlimrRecordJob
  include Sidekiq::Job

  def perform(payload)
    logger.info "Creating GLiMR Records with args #{payload.symbolize_keys}" if Rails.env.production?
    res = GlimrDirectApiClient::RegisterNewCase.call(payload.symbolize_keys)
    logger.info res.response_body

    raise GlimrError, "No response provided" unless res.response_body
    Sentry.capture_exception(GlimrError) unless res.response_body
  end
end
