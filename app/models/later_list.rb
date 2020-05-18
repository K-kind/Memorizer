class LaterList < ApplicationRecord
  belongs_to :user
  validates :word, presence: true, length: { maximum: 30 }
end
