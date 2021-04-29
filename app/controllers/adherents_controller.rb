class AdherentsController < ApplicationController
  def index
    @adherents = Adherent.all
  end

  def show
    @adherent = Adherent.find(params[:id])
  end

  def new
    @adherent = Adherent.new
  end

  def create
    @adherent = Adherent.new(adherent_params)
    if @adherent.save
      flash[:success] = "L'étudiant a été créé."
      redirect_to @adherent
    else
      flash[:error] = "Erreur d'execution"
      render 'new'
    end
  end

  def edit
    @adherent = Adherent.find(params[:id])
  end

  def update
    @adherent = Adherent.find(params[:id])
    if @adherent.update(adherent_params)
      flash[:success] = "L'étudiant a été mis à jour"
      redirect_to @adherent
    else
      flash[:error] = "Erreur d'execution"
      render 'edit'
    end
  end

  def destroy
    @adherent = Adherent.find(params[:id])
    if @adherent.destroy
      flash[:success] = "L'étudiant a été supprimé"
      redirect_to adherents_path
    else
      flash[:error] = "Erreur d'execution"
      redirect_to pages_path
    end
  end

  private

  def adherent_params
    params.require(:adherent).permit(
      :prenom, :nom,
      :mail, :telephone,
      :adresse, :codepostal, :ville,
      :date_naissance, :numero_securite_social, :commune_naissance, :codepostal_naissance,
      :nom_banque, :iban, :bic,
      :annee_mandat, :campus, :pole, :poste,
      :demission, :alumni_ejc, :membre, :master,
      :cvec, :ba, :cotisation, :certificat_scolarite, :carte_vital, :carte_identite
    )
  end
end
