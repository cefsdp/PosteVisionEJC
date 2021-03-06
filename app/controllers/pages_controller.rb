require "google_drive"
require "open-uri"
require 'rexml/document'
require 'rexml/text'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @navbar = true
    redirect_to etudes_path if user_signed_in?
  end

  def loader_etude
    getting_etude
  end

  def saver_etude
    saving_etude
  end

  def loader_adherent
    Adherent.delete_all
    getting_adherent
  end

  def saver_adherent
    saving_adherent
  end

  def testing_page
    zip = Zip::ZipFile.open("app/assets/docs/doc_type.docx")
    y = generer_triage
    y.each do |zip_file|
      file = zip.find_entry(zip_file)
      doc = Nokogiri::XML.parse(file.get_input_stream)
      changes.each do |change|
        doc.xpath("//text()[.='#{change[:title]}']").each do |part|
          part.content = change[:content]
        end
      end
    end
  end

  private

  def generer_triage
    buffer = []
    Zip::ZipFile.open("app/assets/docs/doc_type.docx").each do |file|
      buffer << file.name
    end
    final = []
    buffer.each do |thing|
      buff = []
      buff << thing if thing.end_with?(".xml")
      buff.each do |object|
        final << object if object.start_with?("word/")
      end
    end
    return final
  end

  def init_google_session
    @session = GoogleDrive::Session.from_service_account_key("config/google_config.json")
  end

  def getting_etude
    init_google_session
    @ws = @session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("880104571")
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
      nom_client: "N/A", prenom_client: "N/A", appelation_client: "N/A",
      poste_client: "N/A", adresse: "N/A", codepostal: "N/A", ville: "N/A",
      mail: @ws[row, 15], telephone: @ws[row, 14],
      nbre_propcom: @ws[row, 16], nbre_convetu: @ws[row, 18], conv_cadre: @ws[row, 20],
      date_propcom: @ws[row, 17], date_convetu: @ws[row, 19], date_convcadre: @ws[row, 21],
      num_bdc: @ws[row, 22], budget_HT: 0, taux_marge: @ws[row, 24],
      nbre_av_je_methodo: 0, nbre_av_je_delais: 0, nbre_av_je_budget: 0, nbre_av_je_rupture: 0, nbre_av_je_rm: 0,
      nbre_av_client_methodo: 0, nbre_av_client_delais: 0, nbre_av_client_budget: 0, nbre_av_client_rupture: 0,
      nbre_av_client_rm: 0, frais_ht: @ws[row, 44], budget_total_ht: @ws[row, 23], budget_total_ttc: 0,
      statut: @ws[row, 49], data_debut_etude: @ws[row, 50]
    }
  end

  def saving_etude
    init_google_session
    @ws = @session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("880104571")
    Etude.all.each_with_index do |etude, row|
      row += 2
      etude.date_demande.nil? ? @ws[row, 1] = "" : @ws[row, 1] = "#{etude.date_demande.year}#{etude.date_demande.month}"
      etude.date_convetu.nil? ? @ws[row, 2] = "" : @ws[row, 2] = "#{etude.date_convetu.year}#{etude.date_convetu.month}"
      @ws[row, 3] = etude.references
      @ws[row,
6] = etude.references
      @ws[row,
7] = etude.nom
      @ws[row,
8] = etude.type_client
      @ws[row, 9] = etude.prestation
      @ws[row, 10] = etude.provenance
      @ws[row,
11] = etude.campus
      @ws[row, 13] = etude.date_demande
      @ws[row, 14] = etude.telephone
      @ws[row, 15] = etude.mail
      @ws[row,
16] = etude.nbre_propcom
      @ws[row,
17] = etude.date_propcom
      @ws[row,
18] = etude.nbre_convetu
      @ws[row,
19] = etude.date_convetu
      @ws[row, 20] = etude.conv_cadre
      @ws[row,
21] = etude.date_convcadre
      @ws[row,
22] = etude.num_bdc
      @ws[row, 23] = etude.budget_total_ht
      @ws[row, 24] = etude.taux_marge
      @ws[row, 44] = etude.frais_ht
      @ws[row, 49] = etude.statut
      @ws[row, 50] = etude.data_debut_etude
      @ws[row, 51] = row
      etude.date_convetu.nil? ? 0 : @ws[row, 52] = etude.date_convetu.mjd - etude.date_demande.mjd
    end
    @ws.save
    redirect_to etudes_url
  end

  def getting_adherent
    init_google_session
    @ws = @session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("1050525217")
    (2..@ws.num_rows).each do |row|
      @adherent = Adherent.new(adherent_params(row))
      @adherent.save
    end
    redirect_to adherents_url
  end

  def adherent_params(row)
    @ws[row, 26] == "OUI" ? alumni_ejc = true : alumni_ejc = false
    @ws[row, 25] == "OUI" ? membre = true : membre = false
    @ws[row, 24] == "OUI" ? master = true : master = false
    @ws[row, 35] == "OUI" ? demission = true : demission = false
    {
      prenom: @ws[row, 2], nom: @ws[row, 3],
      mail: @ws[row, 5], telephone: @ws[row, 4], num_ba: @ws[row, 6],
      adresse: @ws[row, 7], codepostal: @ws[row, 8], ville: @ws[row, 33],
      date_naissance: @ws[row, 9], numero_securite_social: @ws[row, 10], commune_naissance: @ws[row, 11], codepostal_naissance: @ws[row, 12],
      nom_banque: @ws[row, 13], iban: @ws[row, 14], bic: @ws[row, 15],
      annee_mandat: @ws[row, 27], campus: @ws[row, 28], pole: @ws[row, 30], poste: @ws[row, 29],
      cvec: @ws[row, 18], ba: @ws[row, 22], cotisation: @ws[row, 34], certificat_scolarite: @ws[row, 19],
      carte_vital: @ws[row, 20], carte_identite: @ws[row, 21], nationalite: @ws[row, 31],
      alumni_ejc: alumni_ejc, membre: membre, master: master, demission: demission,
      genre: @ws[row, 36]
    }
  end

  def saving_adherent
    init_google_session
    @ws = @session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("1050525217")
    Adherent.all.each_with_index do |adherent, row|
      row += 2
      @ws[row, 1] = adherent.num_ba
      @ws[row, 2] = adherent.prenom
      @ws[row, 3] = adherent.nom
      @ws[row, 4] = adherent.telephone
      @ws[row, 5] = adherent.mail
      @ws[row, 6] = adherent.num_ba
      @ws[row, 7] = adherent.adresse
      @ws[row, 8] = adherent.codepostal
      @ws[row, 9] = adherent.date_naissance
      @ws[row,
10] = adherent.numero_securite_social
      @ws[row,
11] = adherent.commune_naissance
      @ws[row, 12] = adherent.codepostal_naissance
      @ws[row, 13] = adherent.nom_banque
      @ws[row, 14] = adherent.iban
      @ws[row, 15] = adherent.bic
      @ws[row, 18] = adherent.cvec
      @ws[row, 19] = adherent.certificat_scolarite
      @ws[row, 20] = adherent.carte_vital
      @ws[row, 21] = adherent.carte_identite
      @ws[row, 23] = adherent.ba
      @ws[row, 24] = adherent.master
      @ws[row, 25] = adherent.membre
      @ws[row, 26] = adherent.alumni_ejc
      @ws[row, 27] = adherent.annee_mandat
      @ws[row, 28] = adherent.campus
      @ws[row, 29] = adherent.poste
      @ws[row, 30] = adherent.pole
      @ws[row, 31] = adherent.nationalite
      @ws[row, 32] = row
      @ws[row, 33] = adherent.ville
      @ws[row, 34] = adherent.cotisation
      @ws[row, 35] = adherent.demission
      @ws[row, 36] = adherent.genre
    end
    @ws.save
    redirect_to adherents_url
  end
end
