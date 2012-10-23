class UsersController < ApplicationController

	def payment
		@user = current_user
		render layout: "application"
	end

	def activate
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
		render layout: "join"
  end

end
