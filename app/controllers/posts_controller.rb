class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:create, :new]
  before_action :post_finder, only: [:edit, :show, :update, :authenticate_user!]

  def index
    @posts = Post.all
  end

  def show
    post_finder
  end

  def new
    @post = Post.new
  end

  def create
    post_finder
    Post.create(content: params[:post][:content], user_id: current_user.id)
    redirect_to user_path(@user)
  end

  def edit
    post_finder
  end

  def update
    post_finder
    @post.update(update_params)
    redirect_to post_path(@post) 
  end

  private

  def authenticate_user!
    post_finder
    raise "Unauthorized!" unless current_user
    unless current_user == @post.user || current_user.vip? || current_user.admin?
      redirect_to post_path(@post.id), :alert => "Access denied."
    end
  end

  def post_finder
    @post = Post.find(params[:id])
  end

  def update_params
    params.require(:post).permit(:content)
  end

end