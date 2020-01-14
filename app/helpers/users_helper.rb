module UsersHelper
  def overall_ranking
    User.joins(:learned_contents)
        .group(:user_id)
        .having('count(`learned_contents`.`id`) > ?', current_user.learned_contents.count)
        .length + 1
  end

  def monthly_ranking
    User.joins(:learned_contents)
        .where('learned_contents.created_at >= ?', Time.current.beginning_of_month)
        .group(:user_id)
        .having(
          'count(`learned_contents`.`id`) > ?',
          current_user.learned_contents.where('learned_contents.created_at >= ?', Time.current.beginning_of_month).count
        )
        .length + 1
  end
end
