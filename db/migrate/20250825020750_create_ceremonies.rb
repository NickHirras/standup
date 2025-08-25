class CreateCeremonies < ActiveRecord::Migration[8.0]
  def change
    create_table :ceremonies do |t|
      t.string :name
      t.text :description
      t.references :team, null: false, foreign_key: true
      t.string :cadence
      t.time :scheduled_time
      t.string :timezone
      t.boolean :active

      t.timestamps
    end
  end
end
