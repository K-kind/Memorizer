class Question < ApplicationRecord
  belongs_to :learned_content
  validates :question, presence: true, length: { maximum: 1000 }, if: :answer?
  validates :answer, presence: true, length: { maximum: 255 }, if: :question?
  validates :my_answer, length: { maximum: 255 }, on: :question
  after_validation :remove_empty_set
  attr_accessor :my_answer
  attr_accessor :similarity

  # Levenshtein距離は順番に左右される
  # Trigramは多少順番が異なっても評価される
  # 大きい方の値を用いる
  def calculate_similarity
    current_answer = my_answer.downcase
    correct_answer = answer.downcase
    levenshtein = ((1 - Levenshtein.normalized_distance(current_answer, correct_answer)) * 100).floor
    trigram = if current_answer.length >= 3 && correct_answer.length >= 3
                (Trigram.compare(current_answer, correct_answer) * 100).floor
              else
                0
              end
    self.similarity = levenshtein > trigram ? levenshtein : trigram
  end

  private

  def remove_empty_set
    destroy if question.blank? && answer.blank?
  end
end
