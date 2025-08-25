class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :company, null: false, foreign_key: true
    add_column :users, :role, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :timezone, :string
    add_column :users, :notification_preferences, :text
  end
end
