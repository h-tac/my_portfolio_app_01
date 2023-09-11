class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :authenticated, only: [:new]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:success] = t('helpers.flash.login.success')
      redirect_to root_path
    else
      flash.now[:danger] = t('helpers.flash.login.failure')
      render :new
    end
  end

  def destroy
    logout
    flash[:success] = t('helpers.flash.logout')
    redirect_to root_path
  end
end
