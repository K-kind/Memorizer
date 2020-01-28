class LearnedContentsController < ApplicationController
  before_action :logged_in_user, except: [:new]
  before_action :confirm_user_skill, only: [:new]
  before_action :set_learned_content, only: [:show, :edit, :update, :destroy, :question, :answer, :question_show]
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]
  before_action :protect_private_contents, only: [:question, :answer, :question_show]
  before_action :set_collection_select, only: [:new, :edit, :index]
  before_action :set_calendar_today, only: [:create, :answer, :import]
  before_action :no_always_dictionary, only: [:new, :show, :edit]
  before_action :reset_question_back, only: [:index, :new]

  def index
    @q = current_user.learned_contents.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @learned_contents = @q.result.includes(:word_category)
    @word = params[:word]
    unless @word.blank?
      word_definition = WordDefinition.find_by(word: @word)
      @learned_contents = @learned_contents.left_joins(:related_words).where('learned_contents.word_definition_id = ? OR related_words.word_definition_id = ?', word_definition.id, word_definition.id).distinct
    end
    @learned_contents = @learned_contents.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @learned_content = LearnedContent.new
    @new_question = @learned_content.questions.build
    @default_word = params[:default_word]
    @template = current_user&.learn_templates&.last
  end

  def create
    @learned_content = current_user.learned_contents.build(learned_content_params)
    @learned_content.word_definition = WordDefinition.find_by(word: params[:learned_content][:main_word])
    @learned_content.calendar = @calendar_today
    @learned_content.filter_valid_questions # 空白の問題はセーブしない
    valid_question = params[:learned_content][:questions_attributes].values.any? { |question| !question[:question].blank? && !question[:answer].blank? }
    respond_to do |format|
      if @learned_content.valid? && valid_question
        @learned_content.save
        @learned_content.create_related_images(params[:learned_content][:related_image])
        @learned_content.create_related_words(params[:learned_content][:related_word])
        calculate_level(5)
        current_user.set_calendar_to_review(@learned_content.till_next_review)
        flash[:notice] = '学習が記録されました。'
        format.html { redirect_to learn_url(@learned_content) }
      else
        @learned_content.errors[:base] << '1つ以上の問題を入力してください' unless valid_question
        format.js { render 'error' }
      end
    end
  end

  def question
    @today = params[:today]
    session[:question_back] = params[:community] ? request.referer : nil
    return unless (already_imported = current_user.learned_contents.find_by(imported_from: @learned_content.id))

    @learned_content = already_imported
  end

  def answer
    @today = params[:learned_content][:today]
    @learned_content.attributes = learned_content_params
    if @learned_content.save(context: :question) # 仮想属性my_answerのバリデーション
      @average_similarity = @learned_content.average_similarity
      if @learned_content.user != current_user
        @imported = true
        @original_content = @learned_content
        calculate_level(1, 'now')
      elsif @learned_content.till_next_review <= 0
        @learned_content.review_histories.create(similarity_ratio: @average_similarity, calendar_id: @calendar_today.id)
        @learned_content.set_next_cycle
        current_user.set_calendar_to_review(@learned_content.till_next_review) unless @learned_content.completed?
        exp_on_similarity(@average_similarity)
      end
    else
      render 'question'
    end
  end

  def import
    @original_content = LearnedContent.find(params[:id])
    @learned_content = current_user.import_content(@original_content, @calendar_today)
    @original_content.duplicate_children(@learned_content)
    current_user.set_calendar_to_review(@learned_content.till_next_review)
    @message = "\"#{@learned_content.word_definition.word}\"の学習コンテンツをダウンロードしました。"
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
    @learned_content.attributes = learned_content_params
    valid_question = params[:learned_content][:questions_attributes].values.any? { |question| !question[:question].blank? && !question[:answer].blank? }
    respond_to do |format|
      if @learned_content.valid? && valid_question
        @learned_content.save
        @learned_content.create_related_images(params[:learned_content][:related_image])
        @learned_content.create_related_words(params[:learned_content][:related_word])
        flash[:notice] = '学習内容が更新されました。'
        format.html { redirect_to learn_url(@learned_content) }
      else
        @learned_content.errors[:base] << '1つ以上の問題を入力してください' unless valid_question
        format.js { render 'error' }
      end
    end
  end

  def destroy
    @learned_content.destroy
    flash[:notice] = '学習内容を削除しました。'
    redirect_to root_url
  end

  def question_show
    respond_to do |format|
      format.js
    end
  end

  def again
    @learned_content = LearnedContent.find(params[:id])
    if params[:again] == '1'
      @learned_content.review_histories.last.update(again: true)
      @learned_content.update(completed: false) if @learned_content.completed?
      @learned_content.set_next_cycle
      current_user.set_calendar_to_review(@learned_content.till_next_review)
      @message = 'この問題をもう一度同じサイクルで復習します。'
    else
      @learned_content.review_histories.last.update(again: false)
      @learned_content.set_next_cycle
      @message = 'この問題は次の復習サイクルに進みます。'
    end
  end

  private

  def learned_content_params
    params.require(:learned_content).permit(:content, :word_category_id, :is_public, questions_attributes: [:question, :answer, :question_type, :my_answer, :id])
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
