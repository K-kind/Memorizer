FactoryBot.define do
  factory :word_definition do
    word { 'lead' }
    dictionary_data { { 'definition' => 'test' } }
    thesaurus_data { { 'thesaurus' => 'test' } }
  end

  trait :lead do
    dictionary_data { get_dictionary_date('lead') }
    thesaurus_data { get_thesaurus_date('lead') }
  end
end

def get_dictionary_date(word)
  learner_api_key = Rails.application.credentials.webster[:learners_api_key]
  learner_response = Unirest.get "https://www.dictionaryapi.com/api/v3/references/learners/json/#{word}?key=#{learner_api_key}",
                                 headers: { 'Accept' => 'application/json' }
  learner_response.body
end

def get_thesaurus_date(word)
  thesaurus_api_key = Rails.application.credentials.webster[:thesaurus_api_key]
  thesaurus_response = Unirest.get "https://dictionaryapi.com/api/v3/references/thesaurus/json/#{word}?key=#{thesaurus_api_key}",
                                   headers: { 'Accept' => 'application/json' }
  @thesaurus_data = thesaurus_response.body
end
