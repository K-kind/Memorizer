class LearnTemplate < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  validates :content, length: { maximum: 2000 }
end
