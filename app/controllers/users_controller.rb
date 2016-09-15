class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :find_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "login.success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "edit.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def find_user
    unless @user = User.find_by(id: params[:id])
      flash[:danger] = t "find_user.danger"
      redirect_to root_url
    end
  end
end
