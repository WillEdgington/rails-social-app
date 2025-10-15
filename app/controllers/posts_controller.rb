class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    following = current_user.following.pluck(:id)
    followed = Post.where(user_id: following + [current_user.id]).order(created_at: :desc)
    suggested = Post.where.not(user_id: following + [current_user.id]).order(created_at: :desc)
    @posts = feed_merge(followed.to_a, suggested.to_a)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :asc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to @post, notice: "Post updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        if request.referer&.include?(user_path(current_user))
          redirect_to user_path(current_user), notice: "Post deleted."
        else
          redirect_to posts_path, notice: "Post deleted."
        end
      end
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end

  def feed_merge(followed, suggested, minv: 3, maxv: 10)
    return followed if suggested.empty?

    feed = []
    unless followed.empty? || suggested.empty?
      batch = rand(3..10)
      feed << followed.shift(batch)
      feed << suggested.shift
    end

    if followed.any?
      feed << followed
    elsif suggested.any?
      feed << suggested
    end
    feed
  end
end
