class MembersController < ApplicationController

	def index
		@regular_members = Member.where( type: "Regular" )
		@sustaining_members = Member.where( type: "Sustaining" )
		@sponsoring_members = Member.where( type: "Sponsoring" )
	end

	def admin_index
		@members = Member.all
		render layout: "backend"
	end

	def show
		@member = Member.find( params[:id] )
	end

	def portal_show
		@member = Member.find( params[:id] )
		render layout: "portal"
	end

	def new
		@member = Member.new
		render layout: "portal"
	end

	def create
		@member = Member.new( params[:member] )
		@member.type = "Regular"
		if @member.save
			@member.reload
			redirect_to members_portal_show_path( @member.id )
		else
			render "new"
		end
	end

	def edit
		@member = Member.find( params[:id] )
		render layout: "portal"
	end

	def update
		@member = Member.find( params[:id] )
		if @member.update_attributes( params[:member] )
			redirect_to members_portal_show_path( @member.id )
		else
			render "edit"
		end
	end

	def destroy
		Member.find( params[:id] ).destroy
		redirect_to members_admin_index_path
	end

end
