# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

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

# Enable threaded mode
# config.threadsafe!
#
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

  HOST = "mimiuchi.com"

  #フォローしていないユーザにダイレクトメッセージを送信しようとした際に、twitterから返却されるメッセージ
  DONT_SENT_MESSEGE = "あなたをフォローしていないユーザーにダイレクトメッセージを送ることができません"

  #DMのAPI制限がかかった場合のメッセージ
  DM_LIMIT_MESSAGE = "There was an error sending your message: We know you have a lot to say, but you can only send so many direct messages per day"

  #複数送信しようとした場合、Twitterから返却されるメッセージ  
  ALREADY_SAID_MESSAGE = "There was an error sending your message: Whoops! You already said that"

  #ユーザがサスペンド（削除等）されたときのメッセージ
  USER_SUSPENDED_MESSAGE = "User has been suspended"
  
  #ユーザが存在しない場合のメッセージ
  USER_NOTFOUND_MESSAGE = "Not Found"
end
