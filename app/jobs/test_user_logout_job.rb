class TestUserLogoutJob < ApplicationJob
  queue_as :default

  def perform(user, test_logged_in_by)
    return if user.test_logged_in_by.nil? || user.test_logged_in_by != test_logged_in_by

    user.update!(test_logged_in_by: nil) # まだログインしている場合を考慮し、最初にログアウトさせるための処理
    %w[review_histories consulted_words later_lists calendars].each do |objects|
      user.send(objects).where("#{objects}.created_at >= ?", Time.zone.now - 12.hours).destroy_all
    end
    user.learned_contents.where(is_test: false).destroy_all
    user.rollback_to_default_cycle
    user.learned_contents.each.with_index(1) do |learned_content, index|
      # 1, 6, 7問目は本日復習ができる
      learned_content.update!(review_date: Time.zone.today) if index.in?([1, 6, 7])
    end
    test_admin = User.find_by(email: Rails.application.credentials.dig(:seed, :test_admin_email))
    user.favorites.destroy_all
    user.reset_test_words(test_admin)
    user.reset_test_contacts(test_admin)
    user.reset_test_notification
    user.update!(exp: 0, level: 1)
  end
end
