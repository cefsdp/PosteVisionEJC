class IntervenantsController < ApplicationController
  def new
    @intervenant = Intervenant.new
    @etude = Etude.find(params[:etude_id])
  end

  def create
    @intervenant = Intervenant.new(intervenant_params)
    @etude = Etude.find(params[:etude_id])
    if @intervenant.save
      saving_intervenant
      flash[:success] = "Object successfully created"
      redirect_to @etude
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def destroy
    @intervenant = Intervenant.find(params[:id])
    @etude = Etude.find(params[:etude_id])
    if @intervenant.destroy
      saving_intervenant
      flash[:success] = 'Object was successfully deleted.'
      redirect_to @etude
    else
      flash[:error] = 'Something went wrong'
      redirect_to @etude
    end
  end

  private

  def intervenant_params
    params.require(:intervenant).permit(:adherent_id, :phase_id, :num_rm)
  end

  def saving_intervenant
    require "google_drive"
    session = GoogleDrive::Session.from_config("config/client_secret.json")
    @ws = session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("465838081")
    Intervenant.all.each_with_index do |intervenant, row|
      row += 2
      @ws[row, 1] = intervenant.adherent.num_ba
      @ws[row, 2] = intervenant.phase.etude.references
      @ws[row, 3] = intervenant.phase.nom
      @ws[row, 4] = intervenant.num_rm
    end
    @ws.save
  end
end
