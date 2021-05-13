class AddGenreToAdherents < ActiveRecord::Migration[6.1]
  def change
    add_column :adherents, :genre, :string
  end
end
