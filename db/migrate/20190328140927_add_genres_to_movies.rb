class AddGenresToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :genres, :text, array: true, default: [].to_yaml
  end
end
