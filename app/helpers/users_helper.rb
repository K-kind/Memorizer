module UsersHelper
  def overall_ranking
    User.regular
        .joins(:learned_contents)
        .group(:user_id)
        .having('count(`learned_contents`.`id`) > ?', current_user.learned_contents.count)
        .length + 1
  end

  def weekly_ranking
    User.regular
        .joins(:learned_contents)
        .where('learned_contents.created_at >= ?', Time.current.beginning_of_week)
        .group(:user_id)
        .having(
          'count(`learned_contents`.`id`) > ?',
          current_user.learned_contents.where('learned_contents.created_at >= ?', Time.current.beginning_of_week).count
        )
        .length + 1
  end

  def show_provider
    if current_user.provider == 'google_oauth2'
      'google'
    else
      current_user.provider
    end
  end

  def test_user_class
    'disabled-btn' if current_user.is_test_user?
  end

  def guest_class
    'disabled-btn' if current_user.nil?
  end
end
