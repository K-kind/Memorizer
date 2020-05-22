class NotificationMailer < ApplicationMailer
  def user_notification_to_admin(user:, contact:)
    @user = user
    @contact = contact
    type = contact ? 'お問い合わせ' : '新規登録'

    mail to: Admin.last.email, subject: "Memorizer: <#{type}>通知メール"
  end
end
