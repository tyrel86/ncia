class ArticlesController < ApplicationController
	
	before_filter :require_admin, except: [:index, :show]

	def index
		articles = Article.all.to_a
		@articles = Kaminari::PaginatableArray.new( articles ).page(params[:page]).per(4)
	end

	def admin_index
		@articles = Article.all
		render layout: "backend"
	end
	
	def show
		@article = Article.find( params[:title] )
		@article.views += 1
		@article.save
	end

	def new
		@article = Article.new
		render layout: "backend"
	end

	def create
		@article = Article.new( params[:article] )
		@article.views = 0
		if @article.save
			redirect_to articles_admin_index_path
		else
			render "new"
		end
	end

	def edit
		@article = Article.find( params[:id] )
		render layout: "backend"
	end

	def update
		@article = Article.find( params[:id] )
		if @article.update_attributes( params[:article] )
			redirect_to articles_admin_index_path
		else
			render "edit"
		end
	end

	def destroy
		Article.find( params[:id] ).destroy
		redirect_to articles_admin_index_path
	end

end
