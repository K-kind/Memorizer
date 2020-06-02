class ReleaseNote < ApplicationRecord
  VALID_VERSION = /\A[\d]+.[\d]+.[\d]+\Z/.freeze
  validates :content, length: { maximum: 3000 }, presence: true
  validates :version, presence: true, format: { with: VALID_VERSION }
  validates :release_date, presence: true

  attr_accessor :year
  attr_accessor :month
  attr_accessor :day

  scope :latest, -> { order(release_date: :desc) }

  def set_date_variables
    @year = release_date&.year
    @month = release_date&.month
    @day = release_date&.day
  end

  def set_release_date
    self.release_date = Date.new(year.to_i, month.to_i, day.to_i)
  rescue ArgumentError
    self.release_date = nil
  end
end
