class PasswordResetsController < ApplicationController

	before_filter :require_member, only: :execute

	def new
		render layout: "account"
	end

	def execute
		@user = current_user
		if @user.update_attributes(params[:user])
			redirect_to blogs_path, :notice => "Password has been reset!"
		else
			render :edit, layout: "portal"
		end
	end

	#All bellow are email reset
	def create
		if current_user
			redirect_to action: :execute
		end
		user = User.find_by( email: params[:email] )
		if user
			user.send_password_reset
			redirect_to login_url, :notice => "Email sent with password reset instructions."
		else
			redirect_to login_url, :notice => "The email you entered was not the one you signed up with please try again"
		end
	end

	def edit
		if current_user
			@user = current_user
		else
			@user = User.find_by( password_reset_token: params[:id] )
		end
		if current_user
			render "edit_while_logged_in", layout: "portal"
		else
			render layout: "account"
		end
	end

	def update
		@user = User.find_by( password_reset_token: params[:id])
		if @user.password_reset_sent_at < 2.hours.ago
			redirect_to new_password_reset_path, :alert => "Password reset has expired."
		elsif @user.update_attributes(params[:user])
			redirect_to login_url, :notice => "Password has been reset!"
		else
			render :edit, layout: "account"
		end
	end

end
