class PhasesController < ApplicationController
  def new
    @phase = Phase.new
  end

  def create
    @phase = Phase.new(params[:phase])
    if @phase.save
      flash[:success] = "Object successfully created"
      redirect_to @phase
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def edit
    @phase = Phase.find(params[:id])
  end

  def update
    @phase = Phase.find(params[:id])
    if @phase.update(params[:phase])
      flash[:success] = "Object was successfully updated"
      redirect_to @phase
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end

  def destroy
    @phase = Phase.find(params[:id])
    if @phase.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to phases_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to phases_url
    end
  end

  private

  def etude_params
    params.require(:etude).permit(
      :nom, :date_debut, :date_fin, :nbre_interv, :nbre_jeh_indiv, :budget_ht,
      :pvr, :facture
    )
  end
end
