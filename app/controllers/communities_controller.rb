class CommunitiesController < ApplicationController
  before_action :set_collection_selects, only: [:words, :questions]

  def words
    @q = LearnedContent.where(imported: false).ransack(params[:q])
    @learned_contents = @q.result.includes(:word_category, user: :user_skill).latest.page(params[:page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def questions
    @q = LearnedContent.where(is_public: true, imported: false).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @learned_contents = @q.result.includes(:word_category, user: :user_skill).page(params[:page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def ranking
    if params[:period] == '総合'
      @users = User.joins(:learned_contents).group(:user_id).order('count(`learned_contents`.`id`) desc').page(params[:page]).per(20)
    else
      @users = User.joins(:learned_contents).where('learned_contents.created_at >= ?', Time.current.beginning_of_month).group(:user_id).order('count(`learned_contents`.`id`) desc').page(params[:page]).per(20)
      @period = true
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_collection_selects
    @user_skills = UserSkill.all
    @word_categories = WordCategory.all
  end
end
