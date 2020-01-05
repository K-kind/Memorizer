class LearnedContent < ApplicationRecord
  belongs_to :user
  belongs_to :word_category
  belongs_to :word_definition
end
