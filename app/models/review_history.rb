class ReviewHistory < ApplicationRecord
  belongs_to :learned_content
  belongs_to :calendar
  scope :not_again, -> { where(again: false) }
end
