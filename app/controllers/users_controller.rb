class UsersController < ApplicationController

	def payment
		@user = current_user
		render layout: "account"
	end

	def activate
		@user = User.find(params["ID"])
		if @user.member.aproval_hash == params[:activation] and @user.member.price == params["Total"].to_i
			@user.active = true
			@user.save
			redirect_to blogs_path, alert: "Thank you for supporting us. Right now the member portal gives you a featured blog. We will be rolling out more user comunity functionality as time passes. Be sure to check out the member benifits and enjoy."
		else
			redirect_to root_path, alert: "Something went wrong during the confirmation request. Did you change anything? If not sorry we will look into the issue"
		end
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
