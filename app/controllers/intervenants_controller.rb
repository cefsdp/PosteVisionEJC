require "google_drive"

class IntervenantsController < ApplicationController
  def show
    @etude = Etude.find(params[:etude_id])
    @intervenant = Intervenant.find(params[:id])
    rm_document
  end

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

  def init_google_session
    @session = GoogleDrive::Session.from_service_account_key("config/google_config.json")
  end

  def intervenant_params
    params.require(:intervenant).permit(:adherent_id, :phase_id, :num_rm)
  end

  def saving_intervenant
    init_google_session
    @ws = @session.spreadsheet_by_key("1noJZd6kty2Ib0345YhRhgrjDNA0SSXmOhhDbXPsl73M").worksheet_by_gid("465838081")
    Intervenant.all.each_with_index do |intervenant, row|
      row += 2
      @ws[row, 1] = intervenant.adherent.num_ba
      @ws[row, 2] = intervenant.phase.etude.references
      @ws[row, 3] = intervenant.phase.nom
      @ws[row, 4] = intervenant.num_rm
    end
    @ws.save
  end

  def rm_document
    @rm_params = {
      document_id: Document.find_by(nom: "RM"),
      change: [
        { title: "Rmref", content: @intervenant.num_rm },
        { title: "Etuderef", content: @intervenant.phase.etude.references },
        { title: "Numeroba", content: @intervenant.adherent.num_ba },
        { title: "PrenomNom", content: "#{@intervenant.adherent.prenom} #{@intervenant.adherent.nom}" },
        { title: "Adressepostale", content: @intervenant.adherent.adresse },
        { title: "Cpville", content: "#{@intervenant.adherent.codepostal} #{@intervenant.adherent.ville}" },
        { title: "Cliententreprise", content: @intervenant.phase.etude.nom },
        { title: "datefin", content: @intervenant.phase.date_fin.strftime('%d/%m/%Y') },
        { title: "Datedebut", content: @intervenant.phase.date_debut.strftime('%d/%m/%Y') },
        { title: "Ville", content: @intervenant.phase.etude.campus },
        { title: "Indemnis", content: @intervenant.phase.remuneration },
        { title: "Jeh", content: @intervenant.phase.nbre_jeh_indiv },
        { title: "FaitLe", content: Date.today.strftime('%d/%m/%Y') }
      ]
    }
  end
end
