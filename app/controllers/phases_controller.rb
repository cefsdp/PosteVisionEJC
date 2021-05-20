require "google_drive"
@session = GoogleDrive::Session.from_credentials(JSON.parse(ENV.fetch('GOOGLE_API_CREDS')))

class PhasesController < ApplicationController
  def new
    @phase = Phase.new
    @etude = Etude.find(params[:etude_id])
  end

  def create
    @phase = Phase.new(phase_params)
    @etude = Etude.find(params[:etude_id])
    @phase.etude = @etude
    if @phase.save!
      # saving_phase
      redirect_to etude_path(@etude)
    end
  end

  def edit
    @phase = Phase.find(params[:id])
    @etude = Etude.find(params[:etude_id])
  end

  def update
    @phase = Phase.find(params[:id])
    @etude = Etude.find(params[:etude_id])
    if @phase.update(phase_params)
      saving_phase
      flash[:success] = "Object was successfully updated"
      redirect_to @etude
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end

  def destroy
    @phase = Phase.find(params[:id])
    @etude = Etude.find(params[:etude_id])
    if @phase.destroy
      saving_phase
      flash[:success] = 'Object was successfully deleted.'
      redirect_to @etude
    else
      flash[:error] = 'Something went wrong'
      redirect_to @etude
    end
  end

  private

  def init_google_session
    @session = GoogleDrive::Session.from_service_account_key("config/google_config.json")
  end

  def phase_params
    params.require(:phase).permit(
      :nom, :date_debut, :date_fin, :nbre_interv, :nbre_jeh_indiv, :budget_ht,
      :pvr, :facture, :remuneration
    )
  end

  def saving_phase
    init_google_session
    @ws = @session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("1703846856")
    Phase.all.each_with_index do |phase, row|
      row += 2
      @ws[row, 1] = phase.etude.references
      @ws[row, 2] = phase.nom
      @ws[row, 3], @ws[row, 4], @ws[row, 5] = phase.date_debut, phase.date_fin, phase.nbre_interv
      @ws[row, 6], @ws[row, 7], @ws[row, 8] = phase.nbre_jeh_indiv, phase.budget_ht, phase.pvr
      @ws[row, 9], @ws[row, 10] = phase.facture, phase.remuneration
    end
    @ws.save
  end
end
