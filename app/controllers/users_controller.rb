class UsersController < ApplicationController

	def payment
		@user = current_user
		render layout: "account"
	end

	def activate

	end

  def new
    @user = User.new
		render layout: "account"
  end

  def create
    @user = User.new(params[:user])
		@user.admin = false
		@user.active = false
    if @user.save
			cookies.permanent[:auth_token] = @user.auth_token
      redirect_to root_url, :notice => "Sorry this form is a little long. Please take your time with it. The information is used to help all members connect and bring each other meaningfull business."
    else
      render :action => 'new', layout: "account"
    end
  end

  def edit
    @user = current_user
		render layout: "account"
  end

end
