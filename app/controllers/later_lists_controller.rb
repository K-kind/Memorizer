class LaterListsController < ApplicationController
  def index
    @new_list = LaterList.new
    @later_lists = current_user.later_lists.page(params[:page]).per(15)
    respond_to do |format|
      format.js
    end
  end

  def create
  end

  def destroy
  end
end
