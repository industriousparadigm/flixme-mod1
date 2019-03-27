class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :release_year
      t.float :tmdb_rating # converted to 1-5 instead of 1-10
      t.timestamps
    end
  end
end
