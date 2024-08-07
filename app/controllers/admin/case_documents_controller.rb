class Admin::CaseDocumentsController < AdminController
  before_action :set_case

  def show
    return unless @tribunal_case

    files = Uploader.list_files(
      collection_ref: @tribunal_case.files_collection_ref
    )

    @files ||= files.
               map(&:name).
               map do |filepath|
      filepath = filepath.gsub(' ', '%20')
      Uploader::File.new(filepath)
    end
  end

  def tc
    tc = request.url.split('/')[-3..].join('/')
    @tribunal_case = TribunalCase.find_by case_reference: tc
    return unless @tribunal_case

    files = Uploader.list_files(
      collection_ref: @tribunal_case.files_collection_ref
    )

    @files ||= files.
               map(&:name).
               map do |filepath|
      filepath = filepath.gsub(' ', '%20')
      Uploader::File.new(filepath)
    end

    render :show
  end

  private

  def set_case
    @tribunal_case = TribunalCase.find_by files_collection_ref: params[:id]
    nil unless @tribunal_case
  end
end