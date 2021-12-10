require "google_drive"

class NotationIntervenantsController < ApplicationController
  def new
    @etude = Etude.find(params[:etude_id])
    @intervenant = Intervenant.find(params[:intervenant_id])
    @notation_intervenant = NotationIntervenant.new
  end

  def create
    @etude = Etude.find(params[:etude_id])
    @intervenant = Intervenant.find(params[:intervenant_id])
    @notation_intervenant = NotationIntervenant.new(notation_params)
    @notation_intervenant.intervenant = @intervenant
    if @notation_intervenant.save
      saving_notation_intervenant
      flash[:success] = "NotationIntervenant successfully created"
      redirect_to @etude
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def edit
    @etude = Etude.find(params[:etude_id])
    @intervenant = Intervenant.find(params[:intervenant_id])
    @notation_intervenant = NotationIntervenant.find(params[:id])
  end

  def update
    @etude = Etude.find(params[:etude_id])
    @intervenant = Intervenant.find(params[:intervenant_id])
    @notation_intervenant = NotationIntervenant.find(params[:id])
    @notation_intervenant.intervenant_id = @intervenant
    if @notation_intervenant.update_attributes(notation_params)
      saving_notation_intervenant
      flash[:success] = "NotationIntervenant was successfully updated"
      redirect_to @etude
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end

  def destroy
    @notation = NotationIntervenant.find(params[:id])
    if @notation.destroy
      saving_notation_intervenant
      flash[:success] = 'NotationIntervenant was successfully deleted.'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to etudes_path
  end

  private

  def notation_params
    params.require(:notation_intervenant).permit(:action_principale, :deroulement_phase, :avis_etudiant, :qualite_travail,
                                                 :disponibilite, :respect_delais, :recommandation, :commentaire)
  end

  def init_google_session
    @session = GoogleDrive::Session.from_service_account_key("config/google_config.json")
  end
  
  def saving_notation_intervenant
    init_google_session
    @ws = @session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("1326956952")
    NotationIntervenant.all.each_with_index do |notation_intervenant, row|
      row += 2
      @ws[row, 1] = notation_intervenant.intervenant.adherent.num_ba
      @ws[row, 2] = notation_intervenant.intervenant.phase.etude.references
      @ws[row, 3] = notation_intervenant.action_principale
      @ws[row, 4] = notation_intervenant.deroulement_phase
      @ws[row, 5] = notation_intervenant.avis_etudiant
      @ws[row, 6] = notation_intervenant.qualite_travail
      @ws[row, 7] = notation_intervenant.disponibilite
      @ws[row, 8] = notation_intervenant.respect_delais
      @ws[row, 9] = notation_intervenant.recommandation
      @ws[row, 10] = notation_intervenant.commentaire
    end
    @ws.save
  end
end
