class CommunitiesController < ApplicationController
  before_action :set_collection_selects, only: [:words, :questions]

  def words
    user_skill_id = params[:user_skill].to_i
    word_category_id = params[:word_category].to_i
    if user_skill_id == 0 && word_category_id == 0
      @learned_contents = LearnedContent.latest.page(params[:page]).per(3)
    elsif user_skill_id != 0 && word_category_id != 0
      user_skill = UserSkill.find(user_skill_id)
      @learned_contents = user_skill.learned_contents.where(word_category_id: word_category_id).latest.page(params[:page]).per(3)
    elsif user_skill_id != 0
      user_skill = UserSkill.find(user_skill_id)
      @learned_contents = user_skill.learned_contents.latest.page(params[:page]).per(3)
    elsif word_category_id != 0
      @learned_contents = LearnedContent.where(word_category_id: word_category_id).latest.page(params[:page]).per(3)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def questions
    @q = LearnedContent.ransack(params[:q])
    @learned_contents = @q.result.page(params[:page]).per(3)
    # @learned_contents = @q.result.includes(:word_category, user: :user_skill).page(params[:page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def ranking
  end

  private

  def search_params
    params.require(:q).permit(:user_user_skill_id_eq, :word_category_id_eq)
  end

  def set_collection_selects
    @user_skills = UserSkill.all
    @word_categories = WordCategory.all
  end
end
