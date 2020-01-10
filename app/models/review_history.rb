class ReviewHistory < ApplicationRecord
  belongs_to :learned_content
  scope :not_again, -> { where(again: false) }
end
