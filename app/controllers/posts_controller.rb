class PostsController < ApplicationController
  before_action :check_if_authorized_to_post, only: [:new, :create]
  before_action ->(id = params[:id]) { check_if_can_edit_or_destroy(id) }, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @user = current_user
    @post = @user.posts.new
  end

  def edit
    @post = Post.find_by_id(params[:id])
  end

  def create
    @user = current_user
    @post = current_user.posts.new(post_params)

    if @post.save
      @user.add_role :post_author, @post
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
      @user = current_user
      @post = current_user.posts.find_by_id(params[:id])
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
  end

  def destroy
    @user = current_user
    @post = current_user.posts.find_by_id(params[:id])
    if @post.destroy
      redirect_to posts_url, notice: 'Post was successfully destroyed.'
    else
      redirect_to posts_path, warning: "Not authorized"
    end
  end

  private

    def check_if_authorized_to_post
      unless current_user && (current_user.has_role?(:admin) || current_user.has_role?(:author))
        redirect_to "/posts", warning: "Not authorized"
      end
    end

    def check_if_can_edit_or_destroy(post_id)
      post = Post.find_by_id(post_id)
      unless current_user && (current_user.has_role?(:admin) || current_user.has_role?(:post_author, post))
        redirect_to "/posts", warning: "Not authorized"
      end
    end

    def post_params
      params.require(:post).permit(:title, :content, :user_id)
    end
end
