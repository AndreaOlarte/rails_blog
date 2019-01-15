# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :find_own_article, only: %i[edit update destroy]

  def index
    @articles = Article.all.order(created_at: :DESC)
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments.order(:created_at)
  end

  def new
    @article = current_user.articles.new
  end

  def edit; end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private

    # Obtains the given article only if its author is the current user 
    def find_own_article
      @article = current_user.articles.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content)
    end
end
