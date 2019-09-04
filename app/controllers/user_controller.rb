class UserController < ApplicationController
  
  before_action :set_user, only: [:edit, :update, :destroy]
  def set_user
    @user = User.find(params[:id])
  end

  def index
    @users = User.order(:created_at).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    
    res = params.require(:user).permit(:name, :twitterUrl) 
    url = res[:twitterUrl]

    twitterInfo = scraper(url)
    
    #Config UrlShorty
    #Google::UrlShortener::Base.api_key = "AIzaSyC4rZhdzvrqp6ZXKZrur5i97ht4FBqWz00"
    #url =  Google::UrlShortener.shorten!("https://twitter.com/LeksDeKonoha")
    #res[:twitterUrl] = url   

    @user = User.new res 

    @user[:twitterName] = twitterInfo[:username]
    @user[:description] = twitterInfo[:desc]
    @user[:profilePicUrl] = twitterInfo[:profile]
    @user[:coverPicUrl] = twitterInfo[:cover]
    
    if @user.save
      flash[:success] = "Usuario criado com sucesso!"
      redirect_to root_path
    else
      render :new
    end    
  end

  def edit
    render :edit
  end

  def update    
    valores = params.require(:user).permit(:name, :twitterName, :twitterUrl, :description)
    if @user.update valores
        flash[:notice] = "Usuario atualizado com sucesso!"
        redirect_to root_url
    else
        render :edit
    end
  end

  def search
    @query = params[:query]
    @users = User.where("name like ?", "%#{@query}%")
    .or(User.where("description like ?", "%#{@query}%"))
    .or(User.where("twitterName like ?", "%#{@query}%"))

  end  

  def destroy
    @user.destroy
    redirect_to root_url
  end
  
  private
  def scraper (twitter)
    url = "#{twitter}"
    twitterProf = {desc: '',username: '',profile: '',cover: ''}
    
    #checa se o link é valido
    if(!(url.match(/http(?:s)?:\/\/(?:www\.)?twitter\.com\/([a-zA-Z0-9_]+)/)))
      return twitterProf
    end

    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    
    #checa se usuario é valido
    if(parsed_page.css('div.errorpage-global-nav').count != 0)
      return twitterProf 
    end

    twitterProf = {
      desc: parsed_page.css('p.ProfileHeaderCard-bio').text,
      username: parsed_page.css('a.ProfileHeaderCard-screennameLink b').text,
      profile: parsed_page.css('img.ProfileAvatar-image').attr('src').value,
      cover:  '' 
    }    

    #Checa se o usuario tem imagem de capa
    if(parsed_page.css('div.ProfileCanopy-headerBg img.u-hidden').count == 0)
      twitterProf[:cover] = parsed_page.css('div.ProfileCanopy-headerBg img').attr('src').value
    end

    return twitterProf
  end
end
