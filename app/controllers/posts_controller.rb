class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    # change mechanics
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
      redirect_to :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.save
      redirect_to @post, notice: "Post updated."
    else
      redirect_to :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to :root, notice: "Post deleted." }
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
