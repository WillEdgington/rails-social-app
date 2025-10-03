class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_likeable

  def create
    @likeable.likes.create(user: current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @likeable, notice: "Liked" }
    end
  end

  def destroy
    @likeable.likes.find_by(user: current_user)&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @likeable, notice: "Unliked." }
    end
  end

  private
  def find_likeable
    if params[:comment_id]
      @likeable = Comment.find(params[:comment_id])
    elsif params[:post_id]
      @likeable = Post.find(params[:post_id])
    end
  end
end
