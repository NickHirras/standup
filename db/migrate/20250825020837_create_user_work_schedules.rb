class CreateUserWorkSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :user_work_schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.string :timezone
      t.text :days_of_week

      t.timestamps
    end
  end
end
