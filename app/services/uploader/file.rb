class Uploader
  class File < ApiClient
    EXPIRES_IN = 300 # seconds

    attr_reader :key

    def initialize(key)
      super
      @key = key
    end

    def url
      file_uri = @client.generate_uri("#{storage_container_name}/#{key}")

      signer.signed_uri(
        file_uri,
        false,
        service: 'b',
        permissions: 'r',
        content_disposition: :attachment,
        expiry: expires_at
      ).to_s
    end

    def name
      key.partition('/').last
    end

    # Allow two File objects to be compared
    def ==(other)
      key == other.key
    end

    delegate :hash, to: :key

    private

    def expires_at
      (Time.zone.now + EXPIRES_IN).utc.iso8601
    end

    def storage_container_name
      Settings.azure.storage_container
    end
  end
end