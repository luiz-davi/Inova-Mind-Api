require 'nokogiri' 
require 'open-uri'

class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]

  # GET /tags
  def index
    @tags = Tag.all

    render json: @tags
  end
  
  # Buscar
  def quotes
    if Tag.find_by(nome: params[:tag]).nil?
      tag = Tag.create(nome: params[:tag], pesquisada: true)

      salvarFrase(tag)

      render json: tag.frases
    # crowlear página
    else 
      if Tag.find_by(nome: params[:tag]).pesquisada
        render json: Tag.find_by(nome: params[:tag]).frases
      else
        tag = Tag.find_by(nome: params[:tag])
        tag.update(pesquisada: true)

        salvarFrase(tag)

        render json: tag.frases
      end
    end
  end

  def frases
    @frases = Frase.all

    render json: @frases
  end

  def buscar_frase_author
    @frases = Frase.where(author: params[:author])

    render json: @frases
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
      urlAuthor = "http://quotes.toscrape.com"
      
      dados = abrirSite(tagMaster.nome)

      # extraindo dados do html
      dados.search('div.quote').each do |frase|
        quote = frase.css('span.text').text
        author = frase.css('span').css('small').text
        author_about = urlAuthor + frase.css('span').css('a').attribute('href').value

        # caso a frase já exista no banco, ela não será salva novamente
        unless Frase.find_by(quote: quote).nil?
          next
        end

        # criando frase com as informações do site
        fraseMaster = Frase.create quote: quote, author: author, author_about: author_about
        fraseMaster.tags << tagMaster

        # capturando tags e salvando elas no banco
        frase.search('div.tags').css('a.tag').each do |tag|
          # Salvando as tags secundárias
          if tag.text != tagMaster.nome
            # Se a tag não estiver no banco, então ela será salva
            if Tag.find_by(nome: tag.text).nil?
              tagBeta = Tag.new nome: tag.text, pesquisada: false
              tagBeta.save
              fraseMaster.tags << tagBeta
            # Se ela estiver, basta fazer uma busca
            else
              fraseMaster.tags << Tag.find_by(nome: tag.text)
            end
          end
        end
        
        # fim da busca por informações
        next if frase['class'] == 'pager'
      end

    end

    def abrirSite(tag)
      
      # declarando URL
      url = 'http://quotes.toscrape.com/tag'
      
      # Abrindo a url e capturando o código fonte
      response = "#{url}/#{tag}/"
      html = URI.open(response)
      doc = Nokogiri::HTML(html)
      
      # retornando html que contém apenas as frases
      return dados = doc.css('div.row').css('div.col-md-8')
    
    end
end
