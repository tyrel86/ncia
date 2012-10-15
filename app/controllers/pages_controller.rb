class PagesController < ApplicationController
  def home
		@page = Page.where(title: "home").first
		render "show"
  end

  def show
		@page = Page.where(title: params[:title]).first
		if @page.nil?
			redirect_to root_path
		end
  end

  def edit
		@page = Page.where( title: params[:title] ).first	
	
		render layout: "backend"
  end

  def update
		page = Page.where( title: params[:title] ).first
		if page.update_attributes( params[:page] )
			redirect_to "/#{page.title}"
		else
			redirect_to "/pages/#{page.title}/edit"
		end
  end

end
