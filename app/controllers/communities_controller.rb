class CommunitiesController < ApplicationController
  def words
    user_skill_id = params[:user_skill].to_i
    word_category_id = params[:word_category].to_i
    respond_to do |format|
      if user_skill_id == 0 && word_category_id == 0
        @learned_contents = LearnedContent.latest.page(params[:page]).per(3)
      end
      if params[:remote].nil?
        format.html
      else
        if user_skill_id != 0 && word_category_id != 0
          user_skill = UserSkill.find(user_skill_id)
          @learned_contents = user_skill.learned_contents.where(word_category_id: word_category_id).latest.page(params[:page]).per(3)
        elsif user_skill_id != 0
          user_skill = UserSkill.find(user_skill_id)
          @learned_contents = user_skill.learned_contents.latest.page(params[:page]).per(3)
        elsif word_category_id != 0
          @learned_contents = LearnedContent.where(word_category_id: word_category_id).latest.page(params[:page]).per(3)
        end
        format.js
      end
    end
  end

  def questions
  end

  def ranking
  end
end
