class Uploader
  class ApiClient
    def initialize(*_args)
      @client = Azure::Storage::Blob::BlobService.create(
        storage_account_name: Settings.azure.storage_account_name,
        storage_access_key:
      )
    end

    protected

    def signer
      @signer ||= Azure::Storage::Common::Core::Auth::SharedAccessSignature.new(
        Settings.azure.storage_account_name,
        storage_access_key
      )
    end

    private

    def blob_name
      [@collection_ref, @document_key, @filename].compact.join('/')
    end

    def storage_access_key
      if Settings.environment.name == 'demo'
        Settings.azure.new_storage_key
      else
        ENV.fetch('AZURE_STORAGE_KEY')
      end
    end
  end
end
