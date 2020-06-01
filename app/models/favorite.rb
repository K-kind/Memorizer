class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :learned_content
  validates_uniqueness_of :learned_content_id, scope: :user_id
end
