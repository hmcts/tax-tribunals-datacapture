class Uploader
  class ListFiles < ApiClient
    def initialize(collection_ref: nil, document_key: nil)
      super
      @collection_ref = collection_ref
      @document_key = document_key
    end

    def call
      files = @client.list_blobs(
        Settings.azure.storage_container,
        prefix:
      )
      log_files_empty if files.empty?

      files
    rescue KeyError => e # e.g. Env not found
      raise KeyError, e
    rescue StandardError => e
      log_uploader_error(e)
      raise Uploader::UploaderError, e
    end

    private

    def prefix
      "#{[@collection_ref, @document_key].
        compact.join('/')}/"
    end

    def log_files_empty
      Rails.logger.tagged('list_files') do
        Rails.logger.warn("NotFoundError")
      end
    end

    def log_uploader_error(err)
      Rails.logger.tagged('list_files') do
        Rails.logger.warn('Uploader::RequestError': {
                            error: err.inspect, backtrace: err.backtrace
                          })
      end
      Sentry.capture_exception(err)
    end
  end
end
