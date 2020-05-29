class User
  include TestUserContent
end

# UpdateTestUser.newで実行される
class UpdateTestUser < CronJob
  def exec
    test_admin_email = Rails.application.credentials.dig(:seed, :test_admin_email)
    User.where('is_test_user = ? AND email != ?', true, test_admin_email)
        .each(&:update_test_content_time)
  end
end
