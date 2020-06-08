class SearchesController < ApplicationController
  def result
    @word = params[:word].downcase
    @type = params[:type]
    @sub_type = params[:sub_type]
    @learned_content = LearnedContent.find(params[:learned_content_id]) if params[:learned_content_id]
    # 英数字、空白のみ検索
    if @word =~ /^[\w]+[ ]*[\w]+$/ && !@word.blank?
      @word = @word.gsub(/ /, '_')
      if (word_definition = WordDefinition.find_by(word: @word))
        @dictionary_data = word_definition.dictionary_data
        @thesaurus_data = word_definition.thesaurus_data
        @no_thesaurus = true unless @thesaurus_data&.dig(0, 'meta', 'id')
      else
        response_from_merriam(@word)
      end
      # 調べた単語リストに追加
      if current_user && word_definition
        SaveConsultedWordJob.perform_later(current_user, word_definition&.id)
      end
    else
      @not_english = true
    end
    respond_to do |format|
      format.js
    end
  end

  def pixabay
    @word = params[:word]
    response_from_pixabay(@word)
    respond_to do |format|
      format.js
    end
  end

  private

  def response_from_merriam(word)
    learner_api_key = Rails.application.credentials.webster[:learners_api_key]
    learner_response = Unirest.get "https://www.dictionaryapi.com/api/v3/references/learners/json/#{word}?key=#{learner_api_key}",
            headers: { 'Accept' => 'application/json' }
    @dictionary_data = learner_response.body

    thesaurus_api_key = Rails.application.credentials.webster[:thesaurus_api_key]
    thesaurus_response = Unirest.get "https://dictionaryapi.com/api/v3/references/thesaurus/json/#{word}?key=#{thesaurus_api_key}",
            headers: { 'Accept' => 'application/json' }
    @thesaurus_data = thesaurus_response.body

    if learner_response.code == 200 && thesaurus_response.code == 200
      if @dictionary_data&.dig(0, 'meta', 'id')
        SaveDictionaryJob.perform_later(word, @dictionary_data, @thesaurus_data, current_user)
      else
        @word_suggestion = @dictionary_data
      end
      @no_thesaurus = true unless @thesaurus_data&.dig(0, 'meta', 'id')
    elsif learner_response.code != 200
      @dictionary_error_status = learner_response.code
    elsif thesaurus_response.code != 200
      @thesaurus_error_status = thesaurus_response.code
    end
  end

  def response_from_pixabay(word)
    pixabay_api_key = Rails.application.credentials.pixabay[:api_key]
    option = '&orientation=horizontal&per_page=30'
    pixabay_response = Unirest.get "https://pixabay.com/api/?key=#{pixabay_api_key}&q=#{word}#{option}",
              headers: { 'Accept' => 'application/json' }
    if pixabay_response.code == 200
      @images_data = pixabay_response.body
    else
      @images_error_status = pixabay_response.code
    end
  end
end
