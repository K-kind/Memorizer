class NotificationMailer < ApplicationMailer
  def user_notification(user, contact = nil)
    @user = user
    @contact = contact
    type = contact ? 'お問い合わせ' : '新規登録'

    mail to: Admin.last.email, subject: "Memorizer: <#{type}>通知メール"
  end
end
