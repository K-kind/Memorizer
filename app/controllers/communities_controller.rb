class CommunitiesController < ApplicationController
  before_action :logged_in_user
  before_action :set_collection_selects, only: [:words, :questions]
  before_action :no_always_dictionary, only: [:words]

  def words
    @q = LearnedContent.where(imported: false).ransack(params[:q])
    @learned_contents = @q.result.includes(:word_category, user: :user_skill).latest.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def questions
    @q = LearnedContent.where(is_public: true, imported: false).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty? && params[:favorite] != 'DESC'
    @learned_contents = @q.result.includes(:word_category, user: :user_skill).page(params[:page])
    @user_skill_id = params.dig(:q, :user_user_skill_id_eq)
    @word_category_id = params.dig(:q, :word_category_id_eq)
    if params[:favorite] == 'DESC'
      @favorite = params[:favorite]
      @learned_contents = @q.result.includes(:word_category, user: :user_skill).joins(:favorites).group(:learned_content_id).order('count(`favorites`.`id`) desc').page(params[:page])
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def ranking
    if params[:period] == '総合'
      @users = User.regular.joins(:learned_contents).group(:user_id).order('count(`learned_contents`.`id`) desc').page(params[:page]).per(20)
    else
      @users = User.regular.joins(:learned_contents).where('learned_contents.created_at >= ?', Time.current.beginning_of_week).group(:user_id).order('count(`learned_contents`.`id`) desc').page(params[:page]).per(20)
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
