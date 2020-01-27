FactoryBot.define do
  factory :word_definition do
    word { 'lead' }
    dictionary_data { { 'definition' => 'test' } }
    thesaurus_data { { 'thesaurus' => 'test' } }
  end
end
