class User
  include ResetAfterLogout
end

class TestUserLogoutJob < ApplicationJob
  queue_as :default

  def perform(user, test_logged_in_by)
    return if user.test_logged_in_by.nil? || user.test_logged_in_by != test_logged_in_by

    user.reset_after_logout
  end
end
