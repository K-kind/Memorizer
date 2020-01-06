class User < ApplicationRecord
  has_many :later_lists, dependent: :destroy
  has_many :consulted_words, dependent: :destroy
  has_many :learned_contents, dependent: :destroy
  belongs_to :user_skill
  has_secure_password
end
