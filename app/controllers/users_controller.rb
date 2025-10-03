class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @following = current_user.following
    @not_following = User.where.not(id: @following.pluck(:id) + [current_user.id])
    @pending_requests = current_user.pending_follow_requests.includes(:follower)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def follow
    @user = User.find(params[:id])
    current_user.active_follows.create(followed: @user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to users_path, notice: "Follow requested." }
    end
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.active_follows.find_by(followed: @user)&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to users_path, notice: "Unfollowed." }
    end
  end

  def accept_follow
    @user = User.find(params[:id])
    request = current_user.passive_follows.find_by(follower: @users)
    request&.accepted!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path, notice: "Follow request accepted."}
    end
  end

  def reject_follow
    @user = User.find(params[:id])
    request = current_user.passive_follows.find_by(follower: @user)
    request&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to users_path, notice: "Follow request rejected." }
    end
  end
end
