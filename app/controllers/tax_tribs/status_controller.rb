module TaxTribs
  class StatusController < ApplicationController
    def index
      check = Status.check
      render json: check, status: check[:service_status] == 'ok' ? :ok : :internal_server_error
    end

    def liveness
      render json: { status: 'ok' }
    end

    def readiness
      render json: { status: 'ok' }
    end

    def glimr
      check = Status.check_glimr
      render json: check, status: check[:glimr_status] == 'ok' ? :ok : :internal_server_error
    end
  end
end
