class ReviewHistory < ApplicationRecord
  belongs_to :learned_content
  belongs_to :calendar
  scope :not_again, -> { where(again: false) }
  scope :for_q_and_words,
        -> {
          includes(learned_content: [
                     :word_definition,
                     :questions,
                     { related_words: :word_definition }
                   ])
        }
end
