class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.integer :follower_id
      t.integer :followee_id
      t.boolean :is_followed

      t.timestamps
    end

    add_index :follows, %i[follower_id followee_id]
  end
end
