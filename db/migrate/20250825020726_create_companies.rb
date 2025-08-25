class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :domain
      t.text :settings

      t.timestamps
    end
  end
end
