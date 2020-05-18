module CommunitiesHelper
  def question_back_params(session)
    {
      page: session.dig('page'),
      q: {
        s: session.dig('q', 's'),
        user_user_skill_id_eq: session.dig('q', 'user_user_skill_id_eq'),
        word_category_id_eq: session.dig('q', 'word_category_id_eq')
      }
    }
  end
end
