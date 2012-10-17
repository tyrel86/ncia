class FilesController < ApplicationController

	before_filter :require_admin
	
	def admin_index
		@files = File.all.reverse
		render layout: "backend"
  end

  def new
		@file = File.new 
		render layout: "backend"
  end

  def create
		@file = File.create( params[:file] )
		if @file.save
			@file.activate
			redirect_to files_admin_index_path
		else
			render "new"
		end
  end

  def destroy
		b = File.find(params[:id])
		if b.active
			b.destroy
			File.last.activate
		end
		b.destroy
		redirect_to files_admin_index_path
  end

end
