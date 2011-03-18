module Twitter
  module AuthenticationHelpers
    def self.included(controller)
      controller.class_eval do
        helper_method :logged_in?, :current_user
        hide_action :logged_in?, :current_user
      end
    end

    def logged_in?
      !!current_user
    end

    def is_admin?
      !!current_user
    end

    # Accesses the current user from the session.
    # Future calls avoid the database because nil is not equal to false.
    def current_user
      @current_user ||= (login_from_session || login_from_cookie) unless @current_user == false
      #@current_user ||= (login_from_session) unless @current_user == false
    end

    # Store the given user id in the session.
    def current_user=(new_user)
      session[:user_id] = new_user ? new_user.id : nil
      @current_user = new_user || false
    end

    def login_from_session
      self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def login_from_cookie
      user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
        self.current_user = user
      end
    end

    protected
    def authenticate
      deny_access unless logged_in?
    end

    def admin_authenticate
      deny_access_for_admin unless logged_in? and current_user.is_admin?
    end

    def deny_access
      store_location
      if request.mobile.is_a?(Jpmobile::Mobile::Sp)
        render :template => "/sessions/new_mobile_sp"
      elsif request.mobile
        render :template => "/sessions/new_mobile"
      else
        render :template => "/sessions/new"
      end
    end

    def deny_access_for_admin
      store_location
      redirect_to root_path
    end

    def sign_in(profile)
      session[:screen_name] = profile.screen_name if profile
    end

    def redirect_back_or(default)
      session[:return_to] ||= params[:return_to]
      if session[:return_to]
        redirect_to(session[:return_to])
      else
        redirect_to(default)
      end
      session[:return_to] = nil
    end

    def store_location
      session[:return_to] = request.request_uri if request.get?
    end


    def logout_keeping_session!
      session[:user_id] = nil
      @current_user = nil
      cookies.delete(:auth_token)
    end

    def logout_complete
      self.current_user.forget_me if logged_in? and current_user.deleted_at != nil
      cookies.delete :auth_token
      reset_session
    end
  end
end
