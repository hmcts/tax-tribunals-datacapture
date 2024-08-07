require 'rest-client'

module GlimrDirectApiClient
  module Api
    attr_reader :response_body

    # Showing the GLiMR post & response in the container logs is helpful
    # for troubleshooting in the staging environment (when we are using
    # the websocket link to communicate with a GLiMR instance to which
    # we have very limited access.
    # DO NOT SET THIS ENV VAR IN PRODUCTION - we should not be logging
    # this sensitive user data from the live service.
    def post
      @response_body = make_request("#{api_url}#{endpoint}", request_body.to_json)
      Rails.logger.debug { "GLIMR POST: #{endpoint} - #{request_body.to_json}" } if ENV.fetch('GLIMR_API_DEBUG', '') == 'true'
    end

    def timeout
      5
    end

    private

    # This uses the REST response body instead of a simple error string in
    # order to provide a consistent interface for raising errors.  GLiMR errors
    # are indicated by a successful response that has the `:glimrerrorcode` key
    # set. See `::RegisterNewCase` for an example.
    def re_raise_error(body)
      raise Unavailable, body.fetch(:message)
    end

    def parse_response(response_body)
      JSON.parse(response_body, symbolize_names: true).tap do |body|
        # These are required because GLiMR can return errors in an otherwise
        # successful response.
        re_raise_error(body) if body.key?(:glimrerrorcode)
        # `:message` is only returned if there is an error  This *shouldn't*
        # happen as all errors should have both `:glimrerrorcode` and
        # `:message`...
        re_raise_error(body) if body.key?(:message)
      end
    end

    # If this is set using a constant, and the gem is included in a project
    # that uses the dotenv gem, then it will always fall through to the default
    # unless dotenv is included and required before this gem is loaded.
    def api_url
      ENV.fetch('GLIMR_DIRECT_ENABLED', 'false') == 'true' ? ENV.fetch('GLIMR_DIRECT_API_URL') : ENV.fetch('GLIMR_API_URL')
    end

    def make_request(endpoint, body)
      response = client(endpoint, body)
      Rails.logger.debug { "GLIMR RESPONSE: #{response.body}" } if ENV.fetch('GLIMR_API_DEBUG', '') == 'true'
      parse_response(response.body)
    rescue RestClient::RequestTimeout
      re_raise_error(message: 'timed out')
    rescue RestClient::ExceptionWithResponse => e
      if (400..599).cover?(e.http_code)
        re_raise_error(message: e.http_code)
      end
    end

    def api_key
      ENV.fetch('GLIMR_AUTHORIZATION_KEY', '')
    end

    def client(uri, body)
      RestClient::Request.execute(
        method: :post,
        url: uri,
        payload: body,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Authorization' => "apikey #{api_key}"
        },
        timeout:
      )
    end
  end
end