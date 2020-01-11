class LearnedContentsController < ApplicationController
  before_action :set_learned_content, only: [:show, :edit, :update, :question, :answer]
  before_action :set_calendar, only: [:create, :answer]

  def index
  end

  def new
    @learned_content = LearnedContent.new
  end

  def create
    @learned_content = current_user.learned_contents.build(learned_content_params)
    @learned_content.word_definition = WordDefinition.find_by(word: params[:learned_content][:main_word])
    @learned_content.calendar = @calendar_today
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
    @learned_content.attributes = learned_content_params
    if @learned_content.save(context: :question)
      average_similarity = @learned_content.average_similarity
      if @learned_content.till_next_review <= 0
        review_history = @learned_content.review_histories.create(similarity_ratio: average_similarity, calendar_id: @calendar_today.id)
        @learned_content.set_next_cycle
      end
    else
      render 'question'
    end
  end

  def show
    @learned_content = LearnedContent.find(params[:id])
    @word = @learned_content.word_definition.word
  end

  def edit
    @word = @learned_content.word_definition.word
    @word_array = @learned_content.word_array(@word)
  end

  def update
    @learned_content.word_definition = WordDefinition.find_by(word: params[:learned_content][:main_word])
    respond_to do |format|
      if @learned_content.update(learned_content_params)
        @learned_content.create_related_images(params[:learned_content][:related_image])
        @learned_content.create_related_words(params[:learned_content][:related_word])
        flash[:success] = '学習内容が更新されました。'
        format.html { redirect_to learn_url(@learned_content) }
      else
        format.js { render 'error' }
      end
    end
  end

  def destroy
  end

  private

  def learned_content_params
    params.require(:learned_content).permit(:content, :word_category_id, :is_public, questions_attributes: [:question, :answer, :my_answer, :id])
  end

  def set_learned_content
    @learned_content = LearnedContent.find(params[:id])
  end

  def set_calendar
    @calendar_today = current_user.calendars.find_by(calendar_date: Time.zone.today)
  end
end
