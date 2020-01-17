class Calendar < ApplicationRecord
  has_many :learned_contents
  has_many :review_histories
  belongs_to :user

  class << self
    def learn_chart(new_or_review, day)
      (day.prev_month .. day).to_a.map do |d|
        [d, find_by(calendar_date: d)&.send(new_or_review)&.count]
      end
    end
  end
end
