class Contact < ApplicationRecord
  belongs_to :user
  validates :comment, presence: true, length: { maximum: 2500 }
end
