class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :comments
      t.integer :movie_id
      t.integer :user_id
      t.timestamps
    end
  end
end
