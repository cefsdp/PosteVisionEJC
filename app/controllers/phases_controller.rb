class PhasesController < ApplicationController
  def new
    @phase = Phase.new
    @etude = Etude.find(params[:etude_id])
  end

  def create
    @phase = Phase.new(phase_params)
    @etude = Etude.find(params[:etude_id])
    @phase.etude = @etude
    redirect_to etude_path(@etude) if @phase.save!
  end

  def edit
    @phase = Phase.find(params[:id])
    @etude = Etude.find(params[:etude_id])
  end

  def update
    @phase = Phase.find(params[:id])
    @etude = Etude.find(params[:etude_id])
    if @phase.update(phase_params)
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
      flash[:success] = 'Object was successfully deleted.'
      redirect_to @etude
    else
      flash[:error] = 'Something went wrong'
      redirect_to @etude
    end
  end

  private

  def phase_params
    params.require(:phase).permit(
      :nom, :date_debut, :date_fin, :nbre_interv, :nbre_jeh_indiv, :budget_ht,
      :pvr, :facture, :remuneration
    )
  end
end
