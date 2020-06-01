class CommunitiesController < ApplicationController
  before_action :logged_in_user
  before_action :set_collection_selects, only: [:words, :questions]
  before_action :no_always_dictionary, only: [:words]

  def words
    @q = LearnedContent.where(is_public: true).ransack(params[:q])
    @learned_contents = @q.result
                          .includes([:word_definition, related_words: :word_definition])
                          .latest.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def questions
    @q = LearnedContent.where(is_public: true).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @learned_contents = @q.result
                          .for_q_and_words
                          .community_ransack_select
                          .with_favorites_count
                          .page(params[:page])
    session[:question_back] = params unless params[:back]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def ranking
    @learn = true if params[:learn_period] || params[:learn]
    per = 10
    @ranking = params[:page] ? (params[:page].to_i - 1) * per : 0
    @learn_users = if params[:learn_period] == '総合'
                     User.with_contents_ranking
                         .page(params[:page]).per(per)
                   else
                     User.with_contents_ranking
                         .with_weekly_ranking(:learned_contents)
                         .page(params[:page]).per(per)
                   end
    @favorite_users = if params[:favorite_period] == '総合'
                        User.with_favorites_ranking
                            .page(params[:page]).per(per)
                      else
                        User.with_favorites_ranking
                            .with_weekly_ranking(:favorites)
                            .page(params[:page]).per(per)
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
