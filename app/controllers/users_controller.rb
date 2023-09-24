class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :authenticated, only: [:new]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(user_params[:email], user_params[:password])
      flash[:success] = t('helpers.flash.user.register.success')
      redirect_to root_path
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

  def delete_confirm; end

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
