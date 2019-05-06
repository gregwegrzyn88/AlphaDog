class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]

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
    @article = Article.new(article_params)
    @article.user = User.first
    if @article.save
      flash[:success] = "Article Was Successfully Created"
      redirect_to article_path(@article)
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = "Article was successfully updated"
      redirect_to article_path(@article)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @article.destroy
    flash[:danger] = "Article Was Deleted"
    redirect_to articles_path
  end

  private
    def article_params
      params.require(:article).permit(:title, :description)
      
    end

    def set_article
    end

    def set_article
      @article = Article.find(params[:id])
    end
  
end