class TestUserLogoutJob < ApplicationJob
  queue_as :default

  def perform(user, test_logged_in_by)
    # return if user.test_logged_in_by == nil || user.test_logged_in_by != test_logged_in_by
    if user.test_logged_in_by == nil || user.test_logged_in_by != test_logged_in_by
      logger.debug '[TEST USER WAS ALREADY LOGGED OUT]'
    else
      logger.debug '[TEST USER LOGOUT JOB IS CORRECTLY PROCEEDING]'
      user.update!(test_logged_in_by: nil)
    end
  end
end
