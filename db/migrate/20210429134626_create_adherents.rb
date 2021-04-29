class CreateAdherents < ActiveRecord::Migration[6.1]
  def change
    create_table :adherents do |t|
      t.string :prenom
      t.string :nom
      t.string :mail
      t.string :telephone
      t.string :adresse
      t.string :codepostal
      t.string :ville
      t.boolean :master
      t.date :date_naissance
      t.string :numero_securite_social
      t.string :commune_naissance
      t.string :codepostal_naissance
      t.string :nom_banque
      t.string :iban
      t.string :bic
      t.boolean :cvec
      t.boolean :certificat_scolarite
      t.boolean :carte_vital
      t.boolean :carte_identite
      t.boolean :ba
      t.boolean :cotisation
      t.boolean :membre
      t.boolean :alumni_ejc
      t.boolean :demission
      t.string :annee_mandat
      t.string :campus
      t.string :pole
      t.string :poste

      t.timestamps
    end
  end
end
