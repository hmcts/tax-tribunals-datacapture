module SaveAndReturn
  class SaveForm < BaseForm
    attribute :save_or_return, String

    validates :save_or_return, inclusion: { in: [:save_for_later, :return_to_saved_appeal, :continue_with_new_appeal] }
  end
end
