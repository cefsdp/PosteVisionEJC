class AddNationaliteToAdherents < ActiveRecord::Migration[6.1]
  def change
    add_column :adherents, :nationalite, :string
    add_column :adherents, :num_ba, :string
  end
end
