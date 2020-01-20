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
end
