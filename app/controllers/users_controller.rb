class UsersController < ApplicationController

	def payment
		@user = current_user
		render layout: "application"
	end

	def activate
		debugger
		u = User.create( email: params["user"]["email"], password: params["user"]["password"], password_confirmation: params["user"]["password_confirmation"] )
		u.admin = false
		u.active = true
		u.save
		cookies.permanent[:auth_token] = u.auth_token
		
		m = Member.new( name: params["Company"] )

		u.member = m
		u.save

		redirect_to blogs_path, notice: "Thank you for signing up. This is your member portal. You can update you listing. Offer discounts to other members. Check out what members are offering you. Enjoy our exclusive blog"
	end

  def new
    @user = User.new
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
