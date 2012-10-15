class BannersController < ApplicationController

  def admin_index
		@banners = Banner.all.reverse
	
		render layout: "backend"
  end

  def new
		@banner = Banner.new 

		render layout: "backend"
  end

  def create
		@banner = Banner.create( params[:banner] )
		if @banner.save
			@banner.activate
			redirect_to banners_admin_index_path
		else
			render "new"
		end
  end

  def edit
		@banner = Banner.find(params[:id])
	
		render layout: "backend"
  end

  def update
		@banner = Banner.find(params[:id])
		if @banner.update_attributes( params[:banner] )
			redirect_to banners_admin_index_path
		else
			render "edit"
		end
  end

  def destroy
		b = Banner.find(params[:id])
		if b.active
			b.destroy
			Banner.last.activate
		end
		b.destroy
		redirect_to banners_admin_index_path
  end

	def activate
		Banner.find(params[:id]).activate
		redirect_to banners_admin_index_path
	end

end
