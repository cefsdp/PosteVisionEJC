class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @navbar = true
    if user_signed_in?
    end
  end

  def loader_etude
    getting_etude
  end

  def saver_etude
    saving_etude
  end

  def loader_adherent
    getting_etude
  end

  def saver_adherent
    saving_etude
  end

  private

  def getting_etude
    require "google_drive"
    session = GoogleDrive::Session.from_config("config/client_secret.json")
    @ws = session.spreadsheet_by_key("1yvs5IMF0yCZu5sahmroNnWo9RMPZwL2NDE2LQwPjIoI").worksheet_by_gid("1475592455")
    (2..@ws.num_rows).each do |row|
      @etude = Etude.new(etude_params(row))
      @etude.save
    end
    redirect_to etudes_url
  end

  def etude_params(row)
    {
      references: @ws[row, 6], nom: @ws[row, 7], type_client: @ws[row, 8], prestation: @ws[row, 9], provenance: @ws[row, 10],
      campus: @ws[row, 11], date_demande: @ws[row, 13],
      nom_client: "Non enregisté", prenom_client: "Non enregisté", appelation_client: "Non enregisté",
      poste_client: "Non enregisté", adresse: "Non enregisté", codepostal: "Non enregisté", ville: "Non enregisté",
      mail: @ws[row, 15], telephone: @ws[row, 14],
      nbre_propcom: @ws[row, 16], nbre_convetu: @ws[row, 18], conv_cadre: @ws[row, 20],
      date_propcom: @ws[row, 17], date_convetu: @ws[row, 19], date_convcadre: @ws[row, 21],
      num_bdc: @ws[row, 22], budget_HT: 0, taux_marge: @ws[row, 24],
      nbre_av_je_methodo: 0, nbre_av_je_delais: 0, nbre_av_je_budget: 0, nbre_av_je_rupture: 0, nbre_av_je_rm: 0,
      nbre_av_client_methodo: 0, nbre_av_client_delais: 0, nbre_av_client_budget: 0, nbre_av_client_rupture: 0,
      nbre_av_client_rm: 0, frais_ht: @ws[row,  44], budget_total_ht: @ws[row, 23], budget_total_ttc: 0,
      statut: @ws[row, 49], data_debut_etude: @ws[row, 50]
    }
  end

  def saving_etude
    require "google_drive"
    session = GoogleDrive::Session.from_config("config/client_secret.json")
    @ws = session.spreadsheet_by_key("1yvs5IMF0yCZu5sahmroNnWo9RMPZwL2NDE2LQwPjIoI").worksheet_by_gid("1475592455")
    Etude.all.each_with_index do |etude, row|
      row += 2
      etude.date_demande.nil? ? @ws[row, 1] = "" : @ws[row, 1] = "#{etude.date_demande.year}#{etude.date_demande.month}"
      etude.date_convetu.nil? ? @ws[row, 2] = "" : @ws[row, 2] = "#{etude.date_convetu.year}#{etude.date_convetu.month}"
      @ws[row, 3] = etude.references
      @ws[row, 6], @ws[row, 7], @ws[row, 8], @ws[row, 9], @ws[row, 10] = etude.references, etude.nom, etude.type_client, etude.prestation, etude.provenance
      @ws[row, 11], @ws[row, 13], @ws[row, 14], @ws[row, 15] = etude.campus, etude.date_demande, etude.telephone, etude.mail
      @ws[row, 16], @ws[row, 17], @ws[row, 18], @ws[row, 19], @ws[row, 20] = etude.nbre_propcom, etude.date_propcom, etude.nbre_convetu, etude.date_convetu, etude.conv_cadre
      @ws[row, 21], @ws[row, 22], @ws[row, 23], @ws[row, 24] = etude.date_convcadre, etude.num_bdc, etude.budget_total_ht, etude.taux_marge
      @ws[row, 44], @ws[row, 45] = etude.frais_ht
      @ws[row, 49], @ws[row, 50] = etude.statut, etude.data_debut_etude
      @ws[row, 51] = row
      etude.date_convetu.nil? ? 0 : @ws[row, 52] = etude.date_convetu.mjd - etude.date_demande.mjd
    end
    @ws.save
    redirect_to etudes_url
  end

  def getting_adherent
    require "google_drive"
    session = GoogleDrive::Session.from_config("config/client_secret.json")
    @ws = session.spreadsheet_by_key("1yvs5IMF0yCZu5sahmroNnWo9RMPZwL2NDE2LQwPjIoI").worksheet_by_gid("1979299984")
    raise
    (2..@ws.num_rows).each do |row|
      @adherent = Adherent.new(adherent_params(row))
      @adherent.save
    end
    redirect_to adherents_url
  end

  def adherent_params(row)
    {
      references: @ws[row, 6]

    }
  end
end
