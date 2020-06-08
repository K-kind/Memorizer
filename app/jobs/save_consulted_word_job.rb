class SaveConsultedWordJob < ApplicationJob
  queue_as :default

  def perform(user, word_definition_id)
    user.save_consulted_word(word_definition_id)
  end
end
