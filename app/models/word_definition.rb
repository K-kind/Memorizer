class WordDefinition < ApplicationRecord
  has_many :consulted_words, dependent: :destroy
  has_many :learned_contents, dependent: :destroy
  has_many :related_words, dependent: :destroy

  validates :dictionary_data, presence: true
  validates :thesaurus_data, presence: true
  validates :word, presence: true
end
