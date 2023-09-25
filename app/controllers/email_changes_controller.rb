class EmailChangesController < ApplicationController
  skip_before_action :require_login, only: %i[confirm]

  def create
    @user = current_user
    @user.new_email = params[:new_email]

    if @user.valid?
      @user.activation_token = SecureRandom.urlsafe_base64
      @user.activation_token_expires_at = Time.now + 1.day
      @user.save!
      UserMailer.email_change_activation(@user).deliver_now
      flash[:success] = t('helpers.flash.email_change.create')
      redirect_to users_path
    else
      render 'users/edit'
    end
  end

  def confirm
    @user = User.find_by(activation_token: params[:token])
    if @user && @user.activation_token_expires_at > Time.now
      @user.email = @user.new_email
      @user.new_email = nil
      @user.activation_token = nil
      @user.activation_token_expires_at = nil
      @user.save!
      flash[:success] = t('helpers.flash.email_change.success')
      if logged_in?
        redirect_to users_path
      else
        redirect_to login_path
      end
    else
      flash[:danger] = t('helpers.flash.email_change.failure')
      if logged_in?
        redirect_to users_path
      else
        redirect_to login_path
      end
    end
  end
end
