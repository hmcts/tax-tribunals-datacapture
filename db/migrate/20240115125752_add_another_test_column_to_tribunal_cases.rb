class AddAnotherTestColumnToTribunalCases < ActiveRecord::Migration[6.1]
  def change
    add_column :tribunal_cases, :another_test_column, :string
  end
end
