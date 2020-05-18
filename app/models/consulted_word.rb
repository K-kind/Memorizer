class ConsultedWord < ApplicationRecord
  belongs_to :user
  belongs_to :word_definition
end
