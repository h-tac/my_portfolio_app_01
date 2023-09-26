class UserMailer < ApplicationMailer
  def activation_needed_email(user)
    @user = user
    @url  = activate_users_url(token: @user.activation_token)
    mail(to: @user.email, subject: 'アカウント登録認証メール | 自転車空気入れマップ')
  end

  def activation_success_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'アカウント登録が完了しました | 自転車空気入れマップ')
  end

  def email_change_activation(user)
    @user = user
    @url = confirm_email_changes_url(token: @user.activation_token)
    mail(to: @user.new_email, subject: 'メールアドレス変更手続きのご案内 | 自転車空気入れマップ')
  end

  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: @user.email, subject: 'パスワード再設定のご案内 | 自転車空気入れマップ')
  end
end
