class SaveDictionaryJob < ApplicationJob
  queue_as :default

  def perform(word, dictionary_data, thesaurus_data, user)
    unless (word_definition = WordDefinition.find_by(word: word))
      word_definition = WordDefinition.create!(word: word, dictionary_data: dictionary_data, thesaurus_data: thesaurus_data)
    end
    return unless user

    SaveConsultedWordJob.perform_later(user, word_definition.id)
  end
end
