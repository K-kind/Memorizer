class WordCategory < ApplicationRecord
  has_many :learned_contents, dependent: :destroy
end
