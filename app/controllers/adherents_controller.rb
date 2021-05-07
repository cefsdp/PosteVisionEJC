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
      saving_adherent
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
      saving_adherent
      flash[:success] = "L'étudiant a été mis à jour"
      redirect_to @adherent
    else
      flash[:error] = "Erreur d'execution"
      redirect_to adherents_path
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

  def saving_adherent
    require "google_drive"
    session = GoogleDrive::Session.from_config("config/client_secret.json")
    @ws = session.spreadsheet_by_key("1W0P7EjBCJ8r2oVXjgqJ0pfpsPnFKX4pAgVdtmFBQNEg").worksheet_by_gid("521892689")
    Adherent.all.each_with_index do |adherent, row|
      row += 2
      @ws[row, 1], @ws[row, 2], @ws[row, 3] = adherent.id, adherent.prenom, adherent.nom
      @ws[row, 4], @ws[row, 5], @ws[row, 6] = adherent.telephone, adherent.mail, adherent.num_ba
      @ws[row, 7], @ws[row, 8], @ws[row, 9] = adherent.adresse, adherent.codepostal, adherent.date_naissance
      @ws[row, 10], @ws[row, 11], @ws[row, 12] = adherent.numero_securite_social, adherent.commune_naissance, adherent.codepostal_naissance
      @ws[row, 13], @ws[row, 14], @ws[row, 15] = adherent.nom_banque, adherent.iban, adherent.bic
      @ws[row, 18], @ws[row, 19], @ws[row, 20] = adherent.cvec, adherent.certificat_scolarite, adherent.carte_vital
      @ws[row, 21], @ws[row, 23] = adherent.carte_identite, adherent.ba
      @ws[row, 24], @ws[row, 25], @ws[row, 26] = adherent.master, adherent.membre, adherent.alumni_ejc
      @ws[row, 27], @ws[row, 28], @ws[row, 29] = adherent.annee_mandat, adherent.campus, adherent.poste
      @ws[row, 30], @ws[row, 31], @ws[row, 32] = adherent.pole, adherent.nationalite, row
      @ws[row, 33], @ws[row, 34], @ws[row, 35] = adherent.ville, adherent.cotisation, adherent.demission
    end
    @ws.save
  end
end
