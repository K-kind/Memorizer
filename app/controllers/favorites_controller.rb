class FavoritesController < ApplicationController
  before_action :logged_in_user
  before_action :set_original_content

  def create
    @original_content.favorites.create(user_id: current_user.id)
    render 'favorite'
  end

  def destroy
    @original_content.favorites.find_by(user_id: current_user.id).destroy
    render 'favorite'
  end

  private

  def set_original_content
    @original_content = LearnedContent.find(params[:learn_id])
  end
end
