# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

  config.gem 'rspec-rails', :version => '>= 1.3.3', :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))


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

  #DMのAPI制限がかかった場合のメッセージ
  DM_LIMIT_MESSAGE = "There was an error sending your message: We know you have a lot to say, but you can only send so many direct messages per day"

  #複数送信しようとした場合、Twitterから返却されるメッセージ  
  ALREADY_SAID_MESSAGE = "There was an error sending your message: Whoops! You already said that"
  
  #ユーザがサスペンド（削除等）されたときのメッセージ
  USER_SUSPENDED_MESSAGE = "User has been suspended"

  #ユーザが存在しない場合のメッセージ
  USER_NOTFOUND_MESSAGE = "Not Found"
end
