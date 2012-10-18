class SessionsController < ApplicationController
  def new
		render layout: "account"
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
			if params[:remember_me]
				cookies.permanent[:auth_token] = user.auth_token
			else
				cookies[:auth_token] = user.auth_token
			end
			if user.active
				if user.admin
					redirect_to new_banner_path
				else
					redirect_to members_portal_show_path( current_user )
				end
			else
				redirect_to root_path, :notice => "You can enjoy the portal as soon as your account is activated"
			end
		else
			flash.now.alert = "Invalid email or password"
			render "new", layout: "account"
    end
  end

  def destroy
		cookies.delete(:auth_token)
    redirect_to root_url, :notice => "You have been logged out."
  end
end
