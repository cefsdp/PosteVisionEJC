class EtudesController < ApplicationController
  def index
    @etudes = Etude.all.order(:references).reverse
  end

  def show
    @etude = Etude.find(params[:id])
    @phases = @etude.phases
    @intervenants = @etude.intervenants
  end

  def new
    @etude = Etude.new
  end

  def create
    @etude = Etude.new(etude_params)
    if @etude.save
      saving_etude
      flash[:success] = "L'étude a été créé."
      redirect_to @etude
    else
      flash[:error] = "Erreur d'execution"
      render 'new'
    end
  end

  def edit
    @etude = Etude.find(params[:id])
  end

  def update
    @etude = Etude.find(params[:id])
    if @etude.update(etude_params)
      saving_etude
      flash[:success] = "L'étude a été mis à jour"
      redirect_to etude_path(@etude)
    else
      flash[:error] = "Erreur d'execution"
      render 'edit'
    end
  end

  def destroy
    @etude = Etude.find(params[:id])
    if @etude.destroy
      saving_etude
      flash[:success] = "L'étude a été supprimé"
      redirect_to etudes_url
    else
      flash[:error] = "Erreur d'execution"
      redirect_to etudes_url
    end
  end

  private

  def etude_params
    params.require(:etude).permit(
      :references, :nom, :type_client, :prestation, :provenance, :campus,
      :date_demande, :nom_client, :prenom_client, :appelation_client,
      :poste_client, :adresse, :codepostal, :ville, :mail, :telephone,
      :nbre_propcom, :nbre_convetu, :conv_cadre, :date_propcom, :date_convetu,
      :date_convcadre, :num_bdc, :budget_HT, :taux_marge, :nbre_av_je_methodo,
      :nbre_av_je_delais, :nbre_av_je_budget, :nbre_av_je_rupture, :nbre_av_je_rm,
      :nbre_av_client_methodo, :nbre_av_client_delais, :nbre_av_client_budget, :nbre_av_client_rupture,
      :nbre_av_client_rm, :frais_ht, :budget_total_ht, :budget_total_ttc, :statut, :data_debut_etude
    )
  end

  def saving_etude
    require "google_drive"
    session = GoogleDrive::Session.from_config("config/client_secret.json")
    @ws = session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("880104571")
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
  end
end
