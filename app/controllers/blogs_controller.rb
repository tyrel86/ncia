class BlogsController < ApplicationController

	before_filter :require_admin, except: [:index, :show]
	before_filter :require_member, only: [:index, :show]

  def index
		@blogs = Blog.all
		render layout: "portal"
  end

  def admin_index
		@blogs = Blog.all
		render layout: "backend"
  end

  def show
		@blog = Blog.find( params[:id] )
		render layout: "portal"
  end

  def new
		@blog = Blog.new
		render layout: "backend"
  end

  def create
		@blog = Blog.new( params[:blog] )
		@blog.views = 0
		@blog.user = current_user
		if @blog.save
			redirect_to blogs_path
		else
			render "new", layout: "backend"
		end
  end

  def edit
		@blog = Blog.find( params[:id] )
		render layout: "backend"
  end

  def update
		@blog = Blog.find( params[:id] )
		if @blog.update_attributes
			redirect_to blogs_path
		else
			render "edit", layout: "backend"
		end
  end

  def destroy
		Blog.find( params[:id] ).destroy
		render "admin_index"
  end

end
