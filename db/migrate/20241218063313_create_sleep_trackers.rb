class CreateSleepTrackers < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_trackers, id: false do |t|
      t.integer :user_id
      t.datetime :sleep_time
      t.datetime :wake_time
      t.integer :duration

      t.timestamps
    end

    add_index :sleep_trackers, :user_id
  end
end
