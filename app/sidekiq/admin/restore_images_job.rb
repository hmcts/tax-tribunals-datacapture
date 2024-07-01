# TODO: I"m not sure this called from anywhere. Keeping it here for now.

class Admin::RestoreImagesJob
  include Sidekiq::Job
  class UploadError < StandardError; end

  def perform(name)
    @client = Azure::Storage::Blob::BlobService.create(
      storage_account_name: Settings.azure.storage_account_name,
      storage_access_key: storage_access_key
    )

    # Extract separate parts
    collection_ref, folder, filename = name.split('/')

    # Get file data
    data = @client.get_blob('uploadedfiles', name)[1]

    # Create a temporary file
    Tempfile.create('tmpfile') do |temp|
      # Fix the file data and save to temp file
      File.binwrite(temp, Base64.decode64(data).force_encoding('utf-8'))

      # Upload new file
      uploader = DocumentUpload.new(
        temp,
        document_key: folder,
        filename: "restored_#{filename}",
        content_type: MimeMagic.by_path(name).try(:type),
        collection_ref:
      )

      uploader.upload! if uploader.valid?

      raise UploadError, uploader.errors if uploader.errors?
    end
  end

  def storage_access_key
    if Settings.environment.name == 'demo'
      Settings.azure.new_storage_key
    else
      ENV.fetch('AZURE_STORAGE_KEY')
    end
  end
end
