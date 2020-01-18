class Notification < ApplicationRecord
  belongs_to :user
  scope :unchecked, -> { where(checked: false) }
  scope :user_notify, -> { where(to_admin: false) }
  scope :admin_notify, -> { where(to_admin: true) }
end
