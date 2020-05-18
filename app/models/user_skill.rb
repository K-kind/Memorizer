class UserSkill < ApplicationRecord
  has_many :users
  has_many :learned_contents, through: :users
end
