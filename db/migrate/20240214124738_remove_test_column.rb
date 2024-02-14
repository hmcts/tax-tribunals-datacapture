class RemoveTestColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :tribunal_cases, :test_column, :string
  end
end
