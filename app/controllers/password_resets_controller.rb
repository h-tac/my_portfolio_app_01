class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :authenticated, only: %i[new create]

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    flash[:success] = t('helpers.flash.password_reset.create')
    redirect_to login_path
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    return not_authenticated if @user.blank?
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password(params[:user][:password])
      flash[:success] = t('helpers.flash.password_reset.success')
      redirect_to login_path
    else
      flash.now[:danger] = t('helpers.flash.password_reset.failure')
      render :edit
    end
  end
end
