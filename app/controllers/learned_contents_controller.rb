class LearnedContentsController < ApplicationController
  # after_action :call_main_word_definition, only: [:show]

  def index
  end

  def new
    @learned_content = LearnedContent.new
  end

  def create
    @learned_content = current_user.learned_contents.build(learned_content_params)
    @learned_content.word_definition = WordDefinition.find_by(word: params[:learned_content][:main_word])
    respond_to do |format|
      if @learned_content.save
        @learned_content.create_related_images(params[:learned_content][:related_image])
        @learned_content.create_related_words(params[:learned_content][:related_word])
        flash[:success] = '学習が記録されました。'
        format.html { redirect_to learn_url(@learned_content) }
      else
        format.js { render 'error' }
      end
    end
  end

  def question
  end

  def answer
  end

  def show
    @learned_content = LearnedContent.find(params[:id])
    @word = @learned_content.word_definition.word
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def learned_content_params
    params.require(:learned_content).permit(:content, :word_category_id, :is_public, questions_attributes: [:question, :answer])
  end

  def call_main_word_definition
    # @learned_content = LearnedContent.find(params[:id])
    # word_definition = @learned_content.word_definition
    # @dictionary_data = word_definition.dictionary_data
    # @thesaurus_data = word_definition.thesaurus_data
    # @no_thesaurus = true unless @thesaurus_data&.dig(0, 'meta', 'id')
    # # respond_to do |format|
    # #   format.js { render 'searches/result' }
    # # end
  end
end
