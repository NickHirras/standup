class CreateChatIntegrations < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_integrations do |t|
      t.references :company, null: false, foreign_key: true
      t.string :platform
      t.text :config
      t.boolean :active

      t.timestamps
    end
  end
end
