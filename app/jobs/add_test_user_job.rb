class User
  extend TestUserContent
  include TestUserContent
end

class AddTestUserJob < ApplicationJob
  queue_as :default

  def perform
    new_test_uesr = User.add_test_user
    new_test_uesr.reset_test_content
  end
end
