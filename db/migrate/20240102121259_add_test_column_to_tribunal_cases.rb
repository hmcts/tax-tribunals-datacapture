class AddTestColumnToTribunalCases < ActiveRecord::Migration[6.1]
  def change
    add_column :tribunal_cases, :test_column, :string
  end
end
