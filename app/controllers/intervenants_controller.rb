class IntervenantsController < ApplicationController
  def new
    @intervenant = Intervenant.new
    @etude = Etude.find(params[:etude_id])
  end

  def create
    @intervenant = Intervenant.new(intervenant_params)
    @etude = Etude.find(params[:etude_id])
    if @intervenant.save
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
      flash[:success] = 'Object was successfully deleted.'
      redirect_to @etude
    else
      flash[:error] = 'Something went wrong'
      redirect_to @etude
    end
  end

  private

  def intervenant_params
    params.require(:intervenant).permit(:adherent_id, :phase_id)
  end
end
