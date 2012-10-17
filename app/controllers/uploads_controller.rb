class UploadsController < ApplicationController

	before_filter :require_admin
	
	def admin_index
		@uploads = Upload.all.reverse
		render layout: "backend"
  end

  def new
		@upload = Upload.new 
		render layout: "backend"
  end

  def create
		@upload = Upload.create( params[:upload] )
		debugger
		if @upload.save
			redirect_to uploads_admin_index_path
		else
			render "new"
		end
  end

  def destroy
		Upload.find(params[:id]).destroy
		redirect_to uploads_admin_index_path
  end

end
