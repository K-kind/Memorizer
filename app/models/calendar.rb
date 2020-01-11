class Calendar < ApplicationRecord
  has_many :learned_contents
  has_many :review_histories
  belongs_to :user
end
