class Question < ApplicationRecord
  belongs_to :learned_content
  validates :question, presence: true
  validates :answer, presence: true

  # Levenshtein距離は順番に左右される
  # Trigramは多少順番が異なっても評価される
  # 大きい値を用いる
  def answer_similarity(correct_answer)
    my_answer = self.answer.downcase
    correct_answer = correct_answer.downcase
    levenshtein = ((1 - Levenshtein.normalized_distance(my_answer, correct_answer)) * 100).floor
    trigram = (Trigram.compare(my_answer, correct_answer) * 100).floor
    levenshtein > trigram ? levenshtein : trigram
  end
end
