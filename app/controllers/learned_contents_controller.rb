class LearnedContentsController < ApplicationController
  before_action :set_learned_content, only: [:show, :edit, :update, :destroy, :question, :answer, :question_show]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]
  before_action :protect_private_contents, only: [:question, :answer, :question_show]
  before_action :set_collection_select, only: [:new, :edit]
  before_action :set_calendar_today, only: [:create, :answer]

  def index
    @learned_contents = current_user.learned_contents.latest.page(params[:page])
  end

  def new
    @learned_content = LearnedContent.new
    @default_word = params[:default_word]
  end

  def create
    @learned_content = current_user.learned_contents.build(learned_content_params)
    @learned_content.word_definition = WordDefinition.find_by(word: params[:learned_content][:main_word])
    @learned_content.calendar = @calendar_today
    respond_to do |format|
      if @learned_content.save
        @learned_content.create_related_images(params[:learned_content][:related_image])
        @learned_content.create_related_words(params[:learned_content][:related_word])
        calculate_level(5)
        set_calendar_to_review(@learned_content.till_next_review)
        flash[:notice] = '学習が記録されました。'
        format.html { redirect_to learn_url(@learned_content) }
      else
        format.js { render 'error' }
      end
    end
  end

  def question
    @today = params[:today]
    return unless (already_imported = current_user.learned_contents.find_by(imported_from: @learned_content.id))

    @learned_content = already_imported
  end

  def answer
    @today = params[:learned_content][:today]
    # 仮想属性my_answerのバリデーション
    @learned_content.attributes = learned_content_params
    if @learned_content.save(context: :question)
      if @learned_content.user != current_user
        original_content = @learned_content
        @learned_content = original_content.dup
        @learned_content.update(
          user_id: current_user.id,
          calendar_id: @calendar_today.id,
          imported_from: original_content.id,
          imported: true,
          till_next_review: 1
        )
      end
      if original_content
        duplicate_children(original_content, @learned_content)
        set_calendar_to_review(@learned_content.till_next_review)
        # 仮想属性my_answerをimportした問題に入れる
        @learned_content.questions.each_with_index do |question, index|
          question.my_answer = params[:learned_content][:questions_attributes][index.to_s][:my_answer]
        end
        calculate_level(3, 'now')
      end
      average_similarity = @learned_content.average_similarity
      if @learned_content.till_next_review <= 0
        @learned_content.review_histories.create(similarity_ratio: average_similarity, calendar_id: @calendar_today.id)
        @learned_content.set_next_cycle
        set_calendar_to_review(@learned_content.till_next_review) unless @learned_content.completed?
        exp_on_similarity(average_similarity)
      end
      if @learned_content.imported?
        @original_content = LearnedContent.find_by(id: @learned_content.imported_from)
      end
    else
      render 'question'
    end
  end

  def show
    @learned_content = LearnedContent.find(params[:id])
    @word = @learned_content.word_definition.word
    @today = params[:today]
    if @learned_content.imported?
      @original_content = LearnedContent.find_by(id: @learned_content.imported_from)
    end
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
        flash[:notice] = '学習内容が更新されました。'
        format.html { redirect_to learn_url(@learned_content) }
      else
        format.js { render 'error' }
      end
    end
  end

  def destroy
  end

  def question_show
    respond_to do |format|
      format.js
    end
  end

  def again
    learned_content = LearnedContent.find(params[:id])
    if params[:again] == '1'
      learned_content.review_histories.last.update(again: true)
      @message = 'この問題をもう一度同じサイクルで復習します。'
    else
      learned_content.review_histories.last.update(again: false)
      @message = 'この問題は次の復習サイクルに進みます。'
    end
  end

  private

  def learned_content_params
    params.require(:learned_content).permit(:content, :word_category_id, :is_public, questions_attributes: [:question, :answer, :my_answer, :id])
  end

  def set_learned_content
    @learned_content = LearnedContent.find(params[:id])
  end

  def ensure_correct_user
    return if @learned_content.user == current_user

    flash[:danger] = '不正なURLです'
    redirect_to root_url
  end

  def protect_private_contents
    return unless @learned_content.user != current_user && @learned_content.is_public == false

    flash[:danger] = '不正なURLです'
    redirect_to root_url
  end

  def set_collection_select
    @word_categories = WordCategory.all
  end

  def set_calendar_today
    @calendar_today = current_user.calendars.find_or_create_by!(calendar_date: Time.zone.today)
  end

  def set_calendar_to_review(till_next_review)
    current_user.calendars.find_or_create_by!(calendar_date: Time.zone.today + till_next_review)
  end

  def duplicate_children(original_content, learned_content)
    ['related_image', 'related_word', 'question'].each do |model|
      original_content.send("#{model}s").each do |object|
        duplicated = object.dup
        duplicated.learned_content = learned_content
        duplicated.save
      end
    end
  end

  def calculate_level(exp, now = nil)
    return unless current_user.level_up?(exp)

    if now
      flash.now[:level_up] = "Level UP! Lv.#{current_user.level_id}"
    else
      flash[:level_up] = "Level UP! Lv.#{current_user.level_id}"
    end
  end

  def exp_on_similarity(average_similarity)
    if average_similarity >= 90
      calculate_level(4, 'now')
    elsif average_similarity >= 50
      calculate_level(3, 'now')
    else
      calculate_level(2, 'now')
    end
  end
end
