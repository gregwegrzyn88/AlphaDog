class ArticlesController < ApplicationController
	before_action :set_article, only: [:edit, :update, :show, :destroy]
	before_action :require_user, except: [:show, :index]
	before_action :require_same_user, only: [:edit, :update, :destroy]
	def index
		@order_articles = Article.order(updated_at: :desc)
		@articles = @order_articles.paginate(:page => params[:page], :per_page => 5)
	end

	def new
		@article = Article.new
	end

	def edit
	end

	def create
#logger = Logger.new('article_log.log')
		@article = Article.new(article_params)
		@article.user = current_user
#logger.debug "Article User Count is: #{User.count}"
#logger.debug "User LAST email is: #{@aUser.email}"
		if @article.save
			flash[:success] = "Article successfully created"
			redirect_to article_path(@article)
		else
			render 'new'
		end
	end

	def update
		if @article.update(article_params)
			flash[:success] = "Article successfully updated"
			redirect_to article_path(@article)
		else
			render 'edit'
		end
	end

	def show
	end

	def destroy
		@article.destroy
		flash[:danger] = "Article successfully deleted"
		redirect_to articles_path
	end

	private
		def set_article
			@article = Article.find(params[:id])
		end

		def article_params
			params.require(:article).permit(:title, :description, category_ids: [])
		end

		def require_same_user
			if !logged_in? || (current_user != @article.user && !current_user.admin?)
				flash[:danger] = "You are not authorised to perform that action."
				redirect_to root_path
			end
		end
end