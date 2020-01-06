class User < ApplicationRecord
  has_many :later_lists,      dependent: :destroy
  has_many :consulted_words,  dependent: :destroy
  has_many :learned_contents, dependent: :destroy
  belongs_to :user_skill
  has_secure_password
  validates :name, presence:true, length: { maximum: 15 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, confirmation: true,
                    unless: :uid?,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, unless: :uid?, length: { minimum: 6 }, allow_nil:true
  # validates :user_skill_id
end
