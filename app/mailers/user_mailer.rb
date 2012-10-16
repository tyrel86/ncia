class UserMailer < ActionMailer::Base
  default from: "info@thecannabisindustry.org"

  def password_reset(user)
		@user = user
		mail :to => user.email, :subject => "Password Reset"
	end
end
