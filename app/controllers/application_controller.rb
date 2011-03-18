# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  # use jpmobile
  #trans_sid :always
  
  #before_filter :set_locale
  trans_sid
  mobile_filter
  #include Twitter::AuthenticationHelpers

  helper :all
  helper_method :client, :mimiuchi_client, :is_smart_phone, :is_mobile, :is_pc
  #protect_from_forgery :secret => '6d0b20bbf9203508337aff3214f79efb7a0'
  protect_from_forgery
  #rescue_from Twitter::Unauthorized, :with => :force_sign_in

  filter_parameter_logging "password"

  JP_LOCALES = %w(ja ja-JP)
  AVAILABLE_LOCALES = %w(ja en)

  def set_locale
    @lang = "ja"
    unless is_mobile
      if current_user
        @lang = current_user.locale
      else
        if !cookies[:locale].blank? and AVAILABLE_LOCALES.include?(cookies[:locale])
          @lang = cookies[:locale]
        else
          @lang = get_best_locale_of_request_user
        end
      end
    end
    I18n.locale = @lang
  end

  def get_locale_from_request
    return extract_locale_from_accept_language_header
  end

  def get_best_locale_of_request_user
    #クッキーがあればクッキーを優先する。
    if !cookies[:locale].blank? and AVAILABLE_LOCALES.include?(cookies[:locale])
      return cookies[:locale]
    end

    #Accept-languageから言語情報を取得する
    lang = extract_locale_from_accept_language_header 
    unless lang.blank?
      if JP_LOCALES.include?(lang)
        #localeが日本語圏であれば、jaとする。
        lang = "ja"
      else
        #localeが日本語圏以外であれば、enとする。
        lang = "en"
      end
    else
      #localeが取得できなければjaとする。
      lang = "ja"
    end
    return lang
  end

  def set_locale_cookie(locale)
    cookies[:locale] = { :value => locale, :expires => 10.years.from_now }
  end

  private
  def extract_locale_from_accept_language_header
    unless request.env['HTTP_ACCEPT_LANGUAGE'].blank?
      return request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    else
      return ""
    end
  end

  def is_smart_phone
    case request.mobile
    when Jpmobile::Mobile::Sp
      return true
    else
      return false
    end
  end

  def is_mobile
    case request.mobile
    when Jpmobile::Mobile::Sp
      return false
    else
      return request.mobile ? true : false
    end
  end

  def is_pc
    return request.mobile ? false : true
  end

  private
  def oauth
    @oauth ||= Twitter::OAuth.new(AppConfig::CONSUMER_TOKEN, AppConfig::CONSUMER_SECRET, :sign_in => true)
  end

  def client
    oauth = Twitter::OAuth.new(AppConfig::CONSUMER_TOKEN, AppConfig::CONSUMER_SECRET, :sign_in => true)
    oauth.authorize_from_access(current_user.access_token, current_user.access_secret)
    Twitter::Base.new(oauth)
  end

  def mimiuchi_client
    user = User.find_by_twitter_id(AppConfig::MIMIUCHI_ID)
    oauth = Twitter::OAuth.new(AppConfig::CONSUMER_TOKEN, AppConfig::CONSUMER_SECRET, :sign_in => true)
    oauth.authorize_from_access(user.access_token, user.access_secret)
    Twitter::Base.new(oauth)
  end

  def xauth
    @xauth ||= Twitter::Xauth.new(AppConfig::CONSUMER_TOKEN, AppConfig::CONSUMER_SECRET)
  end

  def force_sign_in(exception)
    reset_session
    flash[:error] = 'Seems your credentials are not good anymore. Please sign in again.'
    redirect_to new_session_path
  end


end
