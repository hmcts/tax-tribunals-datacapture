class Uploader
  class DeleteFile < ApiClient
    def initialize(collection_ref:, document_key:, filename:)
      super
      @collection_ref = collection_ref
      @document_key = document_key
      @filename = filename
    end

    def call
      log_delete

      @client.delete_blob(
        Settings.azure.storage_container,
        blob_name
      )
    rescue KeyError => e # e.g. Env not found
      raise KeyError, e
    rescue StandardError => e
      log_uploader_error(e)
      raise Uploader::UploaderError, e
    end

    private

    def log_delete
      Rails.logger.tagged('delete_file') do
        Rails.logger.info({
                            filename: @filename,
                            collection_ref: @collection_ref,
                            folder: @document_key.to_s
                          })
      end
    end

    def log_uploader_error(err)
      Rails.logger.tagged('delete_file') do
        Rails.logger.warn('Uploader::RequestError':
          {
            error: err.inspect,
            backtrace: err.backtrace
          })
      end
      Sentry.capture_exception(err)
    end
  end
end
