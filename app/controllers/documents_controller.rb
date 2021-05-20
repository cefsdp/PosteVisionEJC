require "open-uri"
require 'rexml/document'
require 'rexml/text'

class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      flash[:success] = "Object successfully created"
      redirect_to @document
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    if @document.update(document_params)
      flash[:success] = "Object was successfully updated"
      redirect_to @document
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    if @document.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to documents_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to documents_url
    end
  end

  def generer
    generer_doc
  end
  private

  def document_params
    params.require(:document).permit(:nom, :template)
  end

  def generer_doc
    document = Document.find(params[:document_id])
    changes = params[:change]
    File.delete("app/assets/docs/doc_type.docx") if File.exist?("app/assets/docs/doc_type.docx")
    tempurl = url_for(document.template)
    tempfile = Down.download(tempurl)
    FileUtils.mv(tempfile.path, "app/assets/docs/doc_type.docx")

    zip = Zip::ZipFile.open("app/assets/docs/doc_type.docx")
    y = generer_triage
    y.each do |zip_file|
      file = zip.find_entry(zip_file)
      doc = Nokogiri::XML.parse(file.get_input_stream)
      changes.each do |change|
        doc.xpath("//text()[.='#{change[:title]}']").each do |part|
          part.content = change[:content]
        end
      end
      zip.get_output_stream(zip_file) { |f| f << doc.to_s }
    end
    zip.close
    send_file "#{Rails.root}/app/assets/docs/doc_type.docx", disposition: 'attachment'
  end

  def generer_triage
    buffer = []
    Zip::ZipFile.open("app/assets/docs/doc_type.docx").each do |file|
      buffer << file.name
    end
    final = []
    buffer.each do |thing|
      buff = []
      buff << thing if thing.end_with?(".xml")
      buff.each do |object|
      final << object if object.start_with?("word/")
      end
    end
    return final
  end
end
