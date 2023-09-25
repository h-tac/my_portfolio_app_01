class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create activate]
  before_action :authenticated, only: [:new]
  before_action :admin_only, only: %i[list spots comments]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('helpers.flash.user.register.procedure')
      redirect_to login_path
    else
      flash.now[:danger] = t('helpers.flash.user.register.failure')
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = t('helpers.flash.user.update.success')
      redirect_to users_path
    else
      flash.now[:danger] = t('helpers.flash.user.update.failure')
      render :edit
    end
  end

  def destroy
    @user = current_user
    if @user.valid_password?(params[:password])
      @user.destroy!
      flash[:success] = t('helpers.flash.user.destroy')
      redirect_to root_path
    else
      flash.now[:danger] = 'パスワードが正しくありません'
      render :delete_confirm
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      flash[:success] = t('helpers.flash.user.register.activate')
      redirect_to login_path
    else
      flash[:danger] = t('helpers.flash.user.register.activate_failure')
      redirect_to login_path
    end
  end

  def delete_confirm; end

  def list
    @users = User.all.order(id: :desc).page(params[:page])
  end

  def remove
    @user = User.find(params[:user_id])
    @user.destroy!
    flash[:success] = t('helpers.flash.user.destroy')
    redirect_to list_users_path
  end

  def spots
    @user = User.find_by(id: params[:user_id])
    @spots = @user.spots.order(id: :desc).page(params[:page])
  end

  def comments
    @user = User.find_by(id: params[:user_id])
    @comments = @user.comments.order(id: :desc).page(params[:page])
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
