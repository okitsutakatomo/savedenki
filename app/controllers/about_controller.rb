class AboutController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :check_env, :only => [:api, :api_new, :dev_auth]

  def index
  end

  def delivery
  end

  def api
    if params[:screen_name]
      screen_name = params[:screen_name]
      user = User.find_by_screen_name(screen_name)
      oauth = Twitter::OAuth.new(AppConfig::CONSUMER_TOKEN, AppConfig::CONSUMER_SECRET, :sign_in => true)
      oauth.authorize_from_access(user.access_token, user.access_secret)
      client = Twitter::Base.new(oauth)
    else
      @t = params[:t]
      @s = params[:s]
      oauth = Twitter::OAuth.new(AppConfig::CONSUMER_TOKEN, AppConfig::CONSUMER_SECRET, :sign_in => true)
      oauth.authorize_from_access(@t, @s)
      client = Twitter::Base.new(oauth)
    end

    if params[:type] == "1"
      if params[:page]
        @page = params[:page].to_i + 1
      else
        @page = 1
      end
      @messages = client.direct_messages :page => @page
      @sentmessages = client.direct_messages_sent :page => @page
      render :layout => false
    else
      @text = client.retweets(47452482846203904)
      p @text
      render :text => @text
    end
  end

  def api_new
    render :layout => false
  end

  def dev_auth
    @user = User.find_by_screen_name(params[:twitter_id])
    self.current_user = @user
    redirect_to root_path
  end

  private
  def check_env
    if RAILS_ENV != "development"
      redirect_to root_path
    end
  end
end
