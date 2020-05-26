class Notice < ApplicationRecord
  validates :content, length: { maximum: 3000 }, presence: true
  validates :release_date, presence: true
end
