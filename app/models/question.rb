class Question < ApplicationRecord
  belongs_to :learned_content
  validates :question, presence: true
  validates :answer, presence: true
end
