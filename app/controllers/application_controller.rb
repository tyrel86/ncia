class ApplicationController < ActionController::Base
  protect_from_forgery
	helper :all
	helper_method :current_user, :logged_in?

	before_filter :get_banner, :get_members_for_banner

	private

	# def force_finish_signup
	# 	return if ( current_user.nil? or current_user.active? )
	# 	path = current_user.decern_next_step
	# 	controller = params[:controller]
	# 	unless User.in_next_step( controller, path )
	# 		redirect_to path
	# 	end
	# end

	def get_banner
		@banner = Banner.the_current
	end

	def get_members_for_banner
		@members_banner = Member.get_featured_array.shuffle
	end

	def logged_in?
    not current_user.nil?
  end

	def current_user
		@current_user ||= User.find_by( auth_token: cookies[:auth_token] ) if cookies[:auth_token]
  end
  
  def require_member
    unless current_user
      flash[:notice] = "You must be logged in to view this page"
      redirect_to new_session_url
      return false
    end
		unless current_user.active
			redirect_to join_path
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
