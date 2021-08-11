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
end
