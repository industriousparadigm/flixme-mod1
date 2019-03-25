class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.integer :friend_a
      t.integer :friend_b
      t.timestamps
    end
  end
end
