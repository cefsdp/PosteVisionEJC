class AddNumrmToIntervenants < ActiveRecord::Migration[6.1]
  def change
    add_column :intervenants, :num_rm, :string
  end
end
