class ContactMessagesController < ApplicationController
	
	skip_before_filter :verify_authenticity_token

	def admin_index
		@messages = ContactMessage.all
		render layout: "backend"
	end

	def create
		ContactMessage.create( params[:contact_message] )
		redirect_to root_path
	end

	def destroy
		ContactMessage.find( params[:id] ).destroy
		redirect_to contact_messages_admin_index_path
	end

end
