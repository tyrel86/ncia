class UsersController < ApplicationController

	def payment
		@user = current_user
		render layout: "application"
	end

	def activate
		if params[:activation] == "false"
			redirect_to join_path, notice: "Your payment was not acepted please try again"
			return true
		end
		u = User.create( email: params["user"]["email"], password: params["user"]["password"], password_confirmation: params["user"]["password_confirmation"] )
		u.admin = false
		u.active = true
		u.save
		cookies.permanent[:auth_token] = u.auth_token
		
		m = Member.new( name: params["Company"] )
		m.type = PriceHelper.get_type_for_price( params["Total"].to_i )
		
		u.member = m
		u.save

		redirect_to blogs_path, notice: "Thank you for joining the National Cannabis Industry Association (NCIA). Your participation will help further our work on behalf of legitimate cannabis businesses.

You will be receiving an e-mail confirmation of your membership shortly. Feel free to contact us at Info@TheCannabisIndustry any time with questions or comments.

Please save your login and password to access to our member portal which contains information on member discounts, an exclusive blog, and more content which will we be adding in the future."
	end

  def new
    @user = User.new
		render layout: "join"
  end

end
