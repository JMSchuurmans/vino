class CommentsController < ApplicationController
  before_action :find_commentable

  def new
    @comment = Comment.new
    @wine = Wine.find(params[:wine_id])
  end

  def create
    @wine = Wine.find(params[:wine_id])
    @comment = @commentable.comments.create(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "Comment posted!"
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "Comment not posted"
      redirect_back(fallback_location: root_path)
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :user_id)
    end

    def find_commentable
      @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
      @commentable = Wine.find_by_id(params[:wine_id]) if params[:wine_id]
    end

end