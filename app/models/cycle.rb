class Cycle < ApplicationRecord
  belongs_to :user
  validates :cycle, numericality: { greater_than: 0 }
end
