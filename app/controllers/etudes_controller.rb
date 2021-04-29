class EtudesController < ApplicationController
  def index
    @etudes = Etude.all
  end

  def show
    @etude = Etude.find(params[:id])
  end

  def new
    @etude = Etude.new
  end

  def create
    @etude = Etude.new(etude_params)
    if @etude.save
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
    if @etude.update_attributes(etude_params)
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
      :references, :nom, :type, :prestation, :provenance, :campus,
      :date_demande, :nom_client, :prenom_client, :appelation_client,
      :poste_client, :adresse, :codepostal, :ville, :mail, :telephone,
      :nbre_propcom, :nbre_convetu, :conv_cadre, :date_propcom, :date_convetu,
      :date_convcadre, :num_bdc, :budget_HT, :taux_marge, :nbre_av_je_methodo,
      :nbre_av_je_delais, :nbre_av_je_budget, :nbre_av_je_rupture, :nbre_av_je_rm,
      :nbre_av_client_methodo, :nbre_av_client_delais, :nbre_av_client_budget, :nbre_av_client_rupture,
      :nbre_av_client_rm, :frais_ht, :budget_total_ht, :budget_total_ttc, :statut, :data_debut_etude
    )
  end
end
