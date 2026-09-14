class AddSessionTokenToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :session_token, :string
  end
end
