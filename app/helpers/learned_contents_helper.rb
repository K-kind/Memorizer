module LearnedContentsHelper
  def similarity_to_color(similarity)
    if similarity >= 90
      'blue'
    elsif similarity >= 50
      'black'
    else
      'red'
    end
  end

  # def till_next_day(till_next_review)
  #   if till_next_review <= 0
  #     '0 days'
  #   elsif till_next_review == 1
  #     '1 day'
  #   else
  #     "#{till_next_review} days"
  #   end
  # end

  def test_content_class(learned_content)
    'disabled-btn' if learned_content.is_test?
  end

  def words_of(learned_content)
    learned_content
      .related_words
      .inject(learned_content.word_definition.word) do |words, related_word|
        words + ', ' + related_word.word_definition.word
      end
  end
end
