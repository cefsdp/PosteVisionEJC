class CreateNotationIntervenants < ActiveRecord::Migration[6.1]
  def change
    create_table :notation_intervenants do |t|
      t.references :intervenant, null: false, foreign_key: true
      t.string :action_principale
      t.integer :deroulement_phase
      t.integer :avis_etudiant
      t.string :qualite_travail
      t.string :disponibilite
      t.integer :respect_delais
      t.string :recommandation
      t.string :commentaire

      t.timestamps
    end
  end
end
