class Calendar < ApplicationRecord
  has_many :learned_contents, dependent: :destroy
  has_many :review_histories, dependent: :destroy
  belongs_to :user
  validates :calendar_date, uniqueness: { scope: :user_id }

  scope :a_month_old,
        -> { where('calendar_date > ?', Time.zone.today - 1.month) }

  scope :with_contents_and_reviews,
        -> {
          left_joins(:learned_contents)
            .joins(
              'LEFT OUTER JOIN learned_contents AS to_do_contents
              ON to_do_contents.review_date = calendars.calendar_date'
            )
            .left_joins(:review_histories)
            .select(
              'calendars.id,
              calendars.calendar_date,
              COUNT(distinct learned_contents.id) AS contents_count,
              COUNT(distinct to_do_contents.id) AS to_do_count,
              COUNT(distinct review_histories.id) AS reviews_count'
            ).group(:id)
        }

  class << self
    def learn_chart(new_or_review, day)
      (day.prev_month..day).to_a.map do |d|
        [d, find_by(calendar_date: d)&.send(new_or_review)&.count]
      end
    end
  end
end
