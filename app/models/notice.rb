class Notice < ApplicationRecord
  validates :content, length: { maximum: 3000 }, presence: true
  validates :expiration, presence: true

  attr_accessor :year
  attr_accessor :month
  attr_accessor :day
  attr_accessor :oclock

  def set_expiration
    self.expiration = Time.zone.parse("#{year}-#{month}-#{day} #{oclock}")
  rescue ArgumentError
    self.expiration = nil
  end
end
