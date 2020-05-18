class RelatedWord < ApplicationRecord
  belongs_to :learned_content
  belongs_to :word_definition
end
