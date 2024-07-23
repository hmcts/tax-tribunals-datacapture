module GlimrDirectApiClient
  class Base
    include GlimrDirectApiClient::Api
    attr_reader :args

    def self.call(*)
      new(*).call
    end

    def initialize(*args)
      @args = args
    end

    def call
      check_request!
      post
      self
    end

    def check_request!; end
  end
end