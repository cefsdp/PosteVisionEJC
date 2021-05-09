class AddRemunerationToPhases < ActiveRecord::Migration[6.1]
  def change
    add_column :phases, :remuneration, :float
  end
end
