class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :release_year
      t.float :tmdb_rating
      t.string :tmdb_synopsis
      t.timestamps
    end
  end
end
