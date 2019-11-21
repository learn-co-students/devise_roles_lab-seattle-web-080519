class UsersController < ApplicationController

  before_action :authenticate_user!, except: [new, :create]
  before_action :find_user, except: [:index, :new, :create]
  before_action :admin_only, only: :destroy

  def index
    @users = User.all
  end

  def show
    if !current_user.admin? && current_user != @user
      flash[:error] = "Access denied."
      redirect_to '/'
    end 
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    if @user.save
      flash[:success] = "User created"
      redirect_to user_path(@user)
    else
      flash[:error] = "User creation failed"
      render :new
    end
  end

  def edit
    byebug
  end

  def update
    byebug
  end

  def destroy
    @user.destroy
    flash[:success] = "Signed out successfully."
    redirect_to users_path, :notice => "User deleted."
  end

  def sign_out
    flash[:success] = "Signed out successfully."
    session.destroy
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def admin_only
    unless current_user.admin? || @user == current_user
      flash[:error] = "Access denied."
      redirect_to users_path, :alert => "Access denied."
    end
  end

end
