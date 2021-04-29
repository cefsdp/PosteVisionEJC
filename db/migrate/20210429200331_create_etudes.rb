class CreateEtudes < ActiveRecord::Migration[6.1]
  def change
    create_table :etudes do |t|
      t.string :references
      t.string :nom
      t.string :type
      t.string :prestation
      t.string :provenance
      t.string :campus
      t.date :date_demande
      t.string :nom_client
      t.string :prenom_client
      t.string :appelation_client
      t.string :poste_client
      t.string :adresse
      t.string :codepostal
      t.string :ville
      t.string :mail
      t.string :telephone
      t.integer :nbre_propcom
      t.integer :nbre_convetu
      t.boolean :conv_cadre
      t.date :date_propcom
      t.date :date_convetu
      t.date :date_convcadre
      t.string :num_bdc
      t.float :budget_HT
      t.float :taux_marge
      t.integer :nbre_av_je_methodo
      t.integer :nbre_av_je_delais
      t.integer :nbre_av_je_budget
      t.integer :nbre_av_je_rupture
      t.integer :nbre_av_je_rm
      t.integer :nbre_av_client_methodo
      t.integer :nbre_av_client_delais
      t.integer :nbre_av_client_budget
      t.integer :nbre_av_client_rupture
      t.integer :nbre_av_client_rm
      t.float :frais_ht
      t.float :budget_total_ht
      t.float :budget_total_ttc
      t.string :statut
      t.date :data_debut_etude

      t.timestamps
    end
  end
end
