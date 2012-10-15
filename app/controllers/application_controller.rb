class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :get_banner, :get_members_for_banner

	private

	def get_banner
		@banner = Banner.the_current
	end

	def get_members_for_banner
		@members_banner = Member.all
	end

end
