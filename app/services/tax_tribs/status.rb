require_relative '../glimr_direct_api_client'

module TaxTribs
  class Status
    def self.check
      new.check
    end

    def self.check_glimr
      new.check_glimr
    end

    def check
      {
        service_status:,
        version:,
        dependencies: {
          glimr_status:,
          database_status:
        }
      }
    end

    def check_glimr
      {
        glimr_status:
      }
    end

    private

    def version
      ENV['APP_GIT_COMMIT'] || 'unknown'
    end

    def database_status
      # This will only catch high-level failures.  PG::ConnectionBad gets
      # raised too early in the stack to rescue here.
      @database_status ||= if ActiveRecord::Base.connection
                             'ok'
                           else
                             'failed'
                           end
    rescue PG::ConnectionBad
      'failed'
    end

    def glimr_status
      @glimr_status ||=
        begin ENV.fetch('GLIMR_API_CLIENT_MOCK', nil) == 'true' ||
          GlimrDirectApiClient::Available.call.available?
              'ok'
        rescue GlimrDirectApiClient::Unavailable, NoMethodError
          'failed'
        end
    end

    def service_status
      if database_status.eql?('ok') &&
        glimr_status.eql?('ok')
        'ok'
      else
        'failed'
      end
    end
  end
end
