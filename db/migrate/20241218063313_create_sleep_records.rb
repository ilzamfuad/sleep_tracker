class CreateSleepRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_records do |t|
      t.string :status
      t.integer :user_id, null: false
      t.datetime :sleep_time, null: false
      t.datetime :wake_time, null: true
      t.integer :duration

      t.timestamps
    end

    add_index :sleep_records, :user_id
  end
end
