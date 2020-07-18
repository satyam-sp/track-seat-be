class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :genre
      t.string :year
      t.string :summary
      t.string :imdb_url

      t.timestamps
    end
  end
end
