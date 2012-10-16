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
		@members_banner = Member.get_array_for_banner
	end

	def logged_in?
    not current_user.nil?
  end

	def current_user
		@current_user ||= User.find_by( auth_token: cookies[:auth_token] ) if cookies[:auth_token]
  end
  
  def require_member
    unless current_user and current_user.active
      flash[:notice] = "You must be logged in to view this page"
      redirect_to new_session_url
      return false
    end
  end
  
  def require_admin
    unless current_user and current_user.admin
      flash[:notice] = "You must be logged in to view this page"
      redirect_to new_session_url
      return false
    end
  end

end
