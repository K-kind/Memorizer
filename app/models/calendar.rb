class Calendar < ApplicationRecord
  has_many :learned_contents, dependent: :destroy
  has_many :review_histories, dependent: :destroy
  belongs_to :user
  validates :calendar_date, uniqueness: { scope: :user_id }

  class << self
    def learn_chart(new_or_review, day)
      (day.prev_month..day).to_a.map do |d|
        [d, find_by(calendar_date: d)&.send(new_or_review)&.count]
      end
    end
  end
end
