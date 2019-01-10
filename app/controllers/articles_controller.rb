# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_own_article, only: %i[edit update destroy]

  # GET /articles
  def index
    @articles = Article.all
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit; end

  # POST /articles
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /articles/1
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
    end
  end

  private

    # Obtains the given article only if its author is the current user 
    def find_own_article
      @article = Article.where(author: current_user).find(params[:id])
    end

    # Article params.
    def article_params
      params.require(:article).permit(:title, :content).merge(:author_id => current_user.id)
    end
end
