require 'json'

require_relative 'glimr_direct_api_client/api'
require_relative 'glimr_direct_api_client/base'

require_relative 'glimr_direct_api_client/available'
require_relative 'glimr_direct_api_client/register_new_case'

module GlimrDirectApiClient
  class RegisterNewCaseFailure < StandardError; end

  class Unavailable < StandardError; end

  class CaseNotFound < StandardError; end

  class RequestError < StandardError; end
end
