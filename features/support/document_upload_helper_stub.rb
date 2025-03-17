module DocumentUploadHelperStub
  def self.stub_uploaded_document_methods
    DocumentUploadHelper.class_eval do
      def uploaded_document?(_document_key)
        false
      end

      def uploaded_document(_document_key)
        nil
      end
    end
  end
end