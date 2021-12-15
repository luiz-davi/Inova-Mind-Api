require 'nokogiri' 
require 'open-uri'

class Api::TagsController < ApplicationController
  TAG = 'simile'
  before_action :set_tag, only: [:show, :update, :destroy]

  # GET /tags
  def index
    @tags = Tag.all

    render json: @tags
  end
  
  def buscarFrase
    if Tag.find_by(nome: TAG).nil?
      tag = Tag.new(nome: TAG, pesquisada: true)
      tag.save
      salvarFrase(tag)
      # crowlear página
    elsif Tag.find_by(nome: TAG).pesquisada
      # retornar informações do banco
    elsif !Tag.find_by(nome: TAG).pesquisada
      # corwlear página
    end
  end

  # GET /tags/1
  def show
    render json: @tag
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      render json: @tag, status: :created, location: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      render json: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.require(:tag).permit(:nome, :pesquisada)
    end

    def salvarFrase(tagMaster)
      frases = []
      # declarando URLs necessárias
      url = 'http://quotes.toscrape.com/tag'
      urlAuthor = "http://quotes.toscrape.com"
      
      # Abrindo a url e capturando o código fonte
      response = "#{url}/#{tagMaster.nome}/"
      html = URI.open(response)
      doc = Nokogiri::HTML(html)
      dados = doc.css('div.row').css('div.col-md-8')

      # extraindo dados do html
      dados.search('div.quote').each do |frase|
        quote = frase.css('span.text').text
        author = frase.css('span').css('small').text
        author_about = urlAuthor + frase.css('span').css('a').attribute('href').value

        # criando frase com as informações do site
        fraseMaster = Frase.new quote: quote, author: author, author_about: author_about
        fraseMaster.tags << tagMaster

        # capturando tags e salvando elas no banco
        frase.search('div.tags').css('a.tag').each do |tag|
            # Salvando as tags secundárias
            if tag.text != tagMaster.nome
              if Tag.find_by(nome: tag.text)
              tagBeta = Tag.new nome: tag.text, pesquisa: false
              tagBeta.save
              fraseMaster.tags << tagBeta
            end
        end
        
        fraseMaster.save
        frases << fraseMaster

        next if frase['class'] == 'pager'
      end
    end

    def salvarTag
    end
end
