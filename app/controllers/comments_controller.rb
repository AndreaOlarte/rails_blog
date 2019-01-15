class CommentsController < ApplicationController
  before_action :find_article, only: %i[new create]
  before_action :find_own_comment, only: %i[edit update destroy]

  def new
    @comment = @article.comments.new
  end

  def edit; end

  def create
    @comment = @article.comments.new(comment_params)

    if @comment.save
      redirect_to @article, notice: 'Comment was posted.'
    else
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.article, notice: 'Comment was edited.'
    else
      render :edit
    end
  end

  def destroy
    article = @comment.article
    @comment.destroy
    redirect_to article, notice: 'Comment was removed.'
  end

  private

    def find_own_comment
      @comment = current_user.comments.find(params[:id])
    end
    
    def find_article
      @article = Article.find(params[:article_id])
    end

    def comment_params
      params.require(:comment).permit(:content).merge(:user_id => current_user.id)
    end
end
