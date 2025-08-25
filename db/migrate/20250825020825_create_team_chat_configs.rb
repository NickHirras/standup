class CreateTeamChatConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :team_chat_configs do |t|
      t.references :team, null: false, foreign_key: true
      t.references :chat_integration, null: false, foreign_key: true
      t.string :chat_space_id
      t.string :chat_space_name
      t.boolean :active

      t.timestamps
    end
  end
end
