# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "mimiuchi.com",
  :authentication => :plain,
  :user_name => "postmaster1@mimiuchi.com",
  :password => "chinko7"
}

module AppConfig

  MIMIUCHI_ID = 220509929 
  # karioka_dev: 220881050
  # 33iuchi: 220509929

  #karioka_development
  #CONSUMER_TOKEN = "bTWPjm7imdLPX9viuIWkQ"
  #CONSUMER_SECRET = "oFVTIbjMJB0IUWjTvbJkhDBiIaaq9YyeAc1qoQCM"

  #管理者とみなすユーザのTwitterID
  ADMIN_TWITTER_IDS = [9281162,50972543,119036381] #okitsu, kishimotto, pianonoki

  #mimiuchi
  CONSUMER_TOKEN = "gaWQgRXl14TozI9DsIm2Cg"
  CONSUMER_SECRET = "wL8FWPru49uFhaeSfr3xOpqZMvihAl3PwDwAqVzFwGo"

  HOST = "localhost:3000"

  #フォローしていないユーザにダイレクトメッセージを送信しようとした際に、twitterから返却されるメッセージ
  DONT_SENT_MESSEGE = "あなたをフォローしていないユーザーにダイレクトメッセージを送ることができません"

  #DMのAPI制限がかかった場合、Twitterから返却されるメッセージ
  DM_LIMIT_MESSAGE = "There was an error sending your message: We know you have a lot to say, but you can only send so many direct messages per day"

  #複数送信しようとした場合、Twitterから返却されるメッセージ  
  ALREADY_SAID_MESSAGE = "There was an error sending your message: Whoops! You already said that"

  #ユーザがサスペンド（削除等）されたときのメッセージ
  USER_SUSPENDED_MESSAGE = "User has been suspended"
  
  #ユーザが存在しない場合のメッセージ
  USER_NOTFOUND_MESSAGE = "Not Found"
end
