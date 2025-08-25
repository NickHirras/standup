class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :ceremony, null: false, foreign_key: true
      t.text :question_text
      t.string :question_type
      t.text :options
      t.boolean :required
      t.integer :order

      t.timestamps
    end
  end
end
