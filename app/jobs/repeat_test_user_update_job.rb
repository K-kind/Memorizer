class User
  include TestUserContent
end

class RepeatTestUserUpdateJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.update_test_content_time
  end
end
