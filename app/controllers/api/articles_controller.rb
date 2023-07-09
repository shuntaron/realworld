class Api::ArticlesController < ApplicationController
  def index
    articles = Article.order(created_at: :desc)
    render json: { articles: articles }, except: [:id, :created_at, :updated_at]
  end
  
  def show
    article = Article.find_by(slug: params[:slug])
    render json: { article: article }, except: [:id]
  end
  
  def create
    article = Article.new(article_params)
    if article.save
      render json: { article: article }, except: [:id, :created_at, :updated_at]
    else
      render json: { errors: article.errors.full_messages }
    end
  end
  
  def update
    article = Article.find_by(slug: params[:slug])
    if article.update(article_params)
      render json: { article: article }, except: [:id, :created_at, :updated_at]
    else
      render json: { errors: article.errors.full_messages }
    end
  end
  
  def destroy
    article = Article.find_by(slug: params[:slug])
    article.destroy
    render json: { article: article }, except: [:id, :created_at, :updated_at]
  end
  
  private
  def article_params
    params.require(:article).permit(:title, :description, :body).merge(slug: title_to_slug)
  end
  
  def title_to_slug
    params.require(:article).permit(:title)[:title].parameterize
  end
end
