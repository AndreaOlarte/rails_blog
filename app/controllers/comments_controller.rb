class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_article, only: %i[new create]
  before_action :find_comment, only: %i[edit update destroy]

  # GET /comments/new
  def new
    @comment = @article.comments.new
  end

  # GET /comments/1/edit
  def edit; end

  # POST /comments
  def create
    @comment = @article.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @article, notice: 'Comment was posted.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.article, notice: 'Comment was edited.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    article = @comment.article
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to article, notice: 'Comment was removed.' }
    end
  end

  private
    def find_comment
      @comment = Comment.find(params[:id])
    end
    
    def find_article
      @article = Article.find(params[:article_id])
    end

    def comment_params
      params.require(:comment).permit(:content).merge(:user_id => current_user.id)
    end
end
