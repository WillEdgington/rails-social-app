class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, except: [:destroy]
  
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @commentable, notice: "Comment added." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
        format.html { redirect_to @commentable, alert: "Unable to add comment." }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @commentable = @comment.commentable
    @comment&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @commentable, notice: "Comment deleted." }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    if params[:comment_id]
      @commentable = Comment.find(params[:comment_id])
    elsif params[:post_id]
      @commentable = Post.find(params[:post_id])
    end
  end
end
