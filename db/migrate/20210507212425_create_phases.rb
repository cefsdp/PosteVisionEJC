class CreatePhases < ActiveRecord::Migration[6.1]
  def change
    create_table :phases do |t|
      t.references :etude, null: false, foreign_key: true
      t.string :nom
      t.date :date_debut
      t.date :date_fin
      t.integer :nbre_interv
      t.integer :nbre_jeh_indiv
      t.float :budget_ht
      t.boolean :pvr
      t.boolean :facture

      t.timestamps
    end
  end
end
