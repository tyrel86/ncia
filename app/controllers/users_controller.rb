class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def new
    @user = User.new
		render layout: "account"
  end

  def create
    @user = User.new(params[:user])
		@user.admin = false
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new', layout: "account"
    end
  end

  def edit
    @user = current_user
		render layout: "account"
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit', layout: "account"
    end
  end
end
