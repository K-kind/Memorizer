test_admin_email = Rails.application.credentials.dig(:seed, :test_admin_email)
User.where('is_test_user = ? AND email != ?', true, test_admin_email).each do |user|
  user.update!(test_logged_in_at: Time.zone.now)
end
