class ApplicationController < ActionController::Base
  protect_from_forgery
	helper :all
	helper_method :current_user, :logged_in?

	before_filter :get_banner, :get_members_for_banner

	private

	def get_banner
		@banner = Banner.the_current
	end

	def get_members_for_banner
		@members_banner = Member.all
	end

	def logged_in?
    session[:user_id].present?
  end

	def current_user
		@current_user ||= User.find_by( auth_token: cookies[:auth_token] ) if cookies[:auth_token]
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to view this page"
      redirect_to new_session_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || root_path)
    session[:return_to] = nil
  end

end
