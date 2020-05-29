class User
  include TestUserContent
end

# rails r ResetAllTestContent.newで走る
class ResetAllTestContent < Batch
  def exec
    test_admin_email = Rails.application.credentials.dig(:seed, :test_admin_email)
    User.where('is_test_user = ? AND email != ?', true, test_admin_email).each(&:reset_test_content)
  end
end
