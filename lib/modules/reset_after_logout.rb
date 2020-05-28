module ResetAfterLogout
  def reset_after_logout
    update!(test_logged_in_by: nil) # まだログインしている場合を考慮し、最初にログアウトさせるための処理
    %w[review_histories consulted_words later_lists calendars].each do |objects|
      send(objects).where("#{objects}.created_at >= ?", Time.zone.now - 12.hours).destroy_all
    end
    learned_contents.where(is_test: false).destroy_all
    rollback_to_default_cycle
    learned_contents.each.with_index(1) do |learned_content, index|
      # 1, 6, 7問目は本日復習ができる
      learned_content.update!(review_date: Time.zone.today) if index.in?([1, 6, 7])
    end
    test_admin = User.find_by(email: Rails.application.credentials.dig(:seed, :test_admin_email))
    favorites.destroy_all
    reset_test_words(test_admin)
    reset_test_contacts(test_admin)
    reset_test_notification
    update!(exp: 0, level: 1)
  end
end
