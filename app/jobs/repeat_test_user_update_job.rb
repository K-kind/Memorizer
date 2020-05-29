class User
  include TestUserContent
end

class RepeatTestUserUpdateJob < ApplicationJob
  queue_as :default

  def perform(user)
    puts "[#{user.name}は現在ログイン中です]"
    user.update_test_content_time
  end
end
