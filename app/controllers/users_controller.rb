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
      flash[:success] = t('helpers.flash.register.success')
      redirect_to root_path
    else
      flash.now[:danger] = t('helpers.flash.register.failure')
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy; end

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
