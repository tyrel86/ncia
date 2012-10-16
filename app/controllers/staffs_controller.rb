class StaffsController < ApplicationController

	before_filter :require_admin, except: [:staff_index, :board_index]

	def staff_index
		@people = Staff.where( type: 0 )
		render "index"
	end	

	def board_index
		@people = Staff.where( type: 1 )
		render "index"
	end

	def admin_index
		@people = Staff.all
		render layout: "backend"
	end

	def new
		@person = Staff.new
		render layout: "backend"
	end

	def create
		@person = Staff.new( params[:staff] )
		if @person.save
			redirect_to staffs_admin_index_path
		else
			render "new"
		end
	end

	def edit
		@person = Staff.find( params[:id] )
		render layout: "backend"
	end

	def update
		@person = Staff.find( params[:id] )
		if @person.update_attributes( params[:staff] )
			redirect_to staffs_admin_index_path
		else
			render "edit"
		end
	end

	def destroy
		Staff.find( params[:id] ).destroy
	end

end
