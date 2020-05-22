class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user, user_activation_token)
    @user = user
    @user_activation_token = user_activation_token
    mail to: user.email, subject: 'Memorizer:本登録用メール'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user, user_reset_token)
    @user = user
    @user_reset_token = user_reset_token
    mail to: user.email, subject: 'Memorizer:パスワードリセット用メール'
  end
end
