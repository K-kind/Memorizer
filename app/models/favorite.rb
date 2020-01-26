class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :learned_content
  validates_uniqueness_of :learned_content_id, scope: :user_id

  scope :all_or_weekly, ->(weekly) do
    if weekly
      where('favorites.created_at >= ?', Time.current.beginning_of_week)
    else
      all
    end
  end
end
