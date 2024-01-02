class AddSubmittedAtToTribunalCase < ActiveRecord::Migration[6.1]
  def change
    add_column :tribunal_cases, :submitted_at, :datetime
  end
end
