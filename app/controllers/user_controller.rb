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
    
    @user = User.new res

    #Check if its a valid Twitter url
    if(url.match(/http(?:s)?:\/\/(?:www\.)?twitter\.com\/([a-zA-Z0-9_]+)/))

      twitterInfo = scraper(url)

      @user[:twitterUrl] = url_shortner(url)
      @user[:twitterName] = twitterInfo[:username]
      @user[:description] = twitterInfo[:desc]
      @user[:profilePicUrl] = twitterInfo[:profile]
      @user[:coverPicUrl] = twitterInfo[:cover]
      
    end
    
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
  def scraper (url)
    twitterProf = {desc: '',username: '',profile: '',cover: ''}    
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    cover = 'https://pbs.twimg.com/profile_banners/783214/1556918042/600x200'
    
    #Check if its a valid user
    if(parsed_page.css('div.errorpage-global-nav').count != 0)
      return twitterProf 
    end

    #Check if user has cover img
    if(parsed_page.css('div.ProfileCanopy-headerBg img.u-hidden').count == 0)
      cover = parsed_page.css('div.ProfileCanopy-headerBg img').attr('src').value
    end

    twitterProf = {
      desc: parsed_page.css('p.ProfileHeaderCard-bio').text,
      username: parsed_page.css('a.ProfileHeaderCard-screennameLink b').text,
      profile: parsed_page.css('img.ProfileAvatar-image').attr('src').value,
      cover: cover 
    }    

    return twitterProf
  end

  def url_shortner(url)
    request = JSON.parse(HTTParty.post('https://api-ssl.bitly.com/v4/shorten', 
      body: {long_url: url}.to_json,
      headers: { "Content-Type": "application/json", authorization: "Bearer 6cf4e8d64cada722632b3e511f8bd468ebeaea23" }
    ).to_json)
    link = request['link']

    return link
  end
end
