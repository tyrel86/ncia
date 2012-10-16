class MembersController < ApplicationController

	before_filter :require_member, only: [:portal_show, :edit, :update]
	before_filter :require_admin, only: [:new, :create, :destroy, :admin_index]
	
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
		@member = current_user.member
		if @member.name.nil?
			render "edit", layout: "portal", notice: "Your member profile which gives you exposure through member discounts and our directory is not filled out. Its very easy just fill out the form bellow. Thank you."
		else
			render layout: "portal"
		end
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
