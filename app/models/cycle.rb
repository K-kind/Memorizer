class Cycle < ApplicationRecord
  belongs_to :user
  validates :cycle, numericality: { greater_than: 0 }

  DEFAULT_CYCLES = [1, 7, 16, 35, 62].freeze
end
