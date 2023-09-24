class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    flash[:danger] = t('helpers.flash.login.require')
    redirect_to login_path
  end

  def authenticated
    redirect_to root_path if logged_in?
  end

  def admin_only
    redirect_to root_path unless current_user.admin?
  end
end
