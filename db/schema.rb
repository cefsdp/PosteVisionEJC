# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_11_113246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "adherents", force: :cascade do |t|
    t.string "prenom"
    t.string "nom"
    t.string "mail"
    t.string "telephone"
    t.string "adresse"
    t.string "codepostal"
    t.string "ville"
    t.boolean "master"
    t.date "date_naissance"
    t.string "numero_securite_social"
    t.string "commune_naissance"
    t.string "codepostal_naissance"
    t.string "nom_banque"
    t.string "iban"
    t.string "bic"
    t.boolean "cvec"
    t.boolean "certificat_scolarite"
    t.boolean "carte_vital"
    t.boolean "carte_identite"
    t.boolean "ba"
    t.boolean "cotisation"
    t.boolean "membre"
    t.boolean "alumni_ejc"
    t.boolean "demission"
    t.string "annee_mandat"
    t.string "campus"
    t.string "pole"
    t.string "poste"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nationalite"
    t.string "num_ba"
    t.string "genre"
  end

  create_table "documents", force: :cascade do |t|
    t.string "nom"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "etudes", force: :cascade do |t|
    t.string "references"
    t.string "nom"
    t.string "type_client"
    t.string "prestation"
    t.string "provenance"
    t.string "campus"
    t.date "date_demande"
    t.string "nom_client"
    t.string "prenom_client"
    t.string "appelation_client"
    t.string "poste_client"
    t.string "adresse"
    t.string "codepostal"
    t.string "ville"
    t.string "mail"
    t.string "telephone"
    t.integer "nbre_propcom"
    t.integer "nbre_convetu"
    t.boolean "conv_cadre"
    t.date "date_propcom"
    t.date "date_convetu"
    t.date "date_convcadre"
    t.string "num_bdc"
    t.float "budget_HT"
    t.float "taux_marge"
    t.integer "nbre_av_je_methodo"
    t.integer "nbre_av_je_delais"
    t.integer "nbre_av_je_budget"
    t.integer "nbre_av_je_rupture"
    t.integer "nbre_av_je_rm"
    t.integer "nbre_av_client_methodo"
    t.integer "nbre_av_client_delais"
    t.integer "nbre_av_client_budget"
    t.integer "nbre_av_client_rupture"
    t.integer "nbre_av_client_rm"
    t.float "frais_ht"
    t.float "budget_total_ht"
    t.float "budget_total_ttc"
    t.string "statut"
    t.date "data_debut_etude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "intervenants", force: :cascade do |t|
    t.bigint "adherent_id", null: false
    t.bigint "phase_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "num_rm"
    t.index ["adherent_id"], name: "index_intervenants_on_adherent_id"
    t.index ["phase_id"], name: "index_intervenants_on_phase_id"
  end

  create_table "notation_intervenants", force: :cascade do |t|
    t.bigint "intervenant_id", null: false
    t.string "action_principale"
    t.integer "deroulement_phase"
    t.integer "avis_etudiant"
    t.string "qualite_travail"
    t.string "disponibilite"
    t.integer "respect_delais"
    t.string "recommandation"
    t.string "commentaire"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["intervenant_id"], name: "index_notation_intervenants_on_intervenant_id"
  end

  create_table "phases", force: :cascade do |t|
    t.bigint "etude_id", null: false
    t.string "nom"
    t.date "date_debut"
    t.date "date_fin"
    t.integer "nbre_interv"
    t.integer "nbre_jeh_indiv"
    t.float "budget_ht"
    t.boolean "pvr"
    t.boolean "facture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "remuneration"
    t.index ["etude_id"], name: "index_phases_on_etude_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "intervenants", "adherents"
  add_foreign_key "intervenants", "phases"
  add_foreign_key "notation_intervenants", "intervenants"
  add_foreign_key "phases", "etudes"
end
