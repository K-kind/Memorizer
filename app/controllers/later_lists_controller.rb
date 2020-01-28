class LaterListsController < ApplicationController
  before_action :logged_in_user
  before_action :set_list_instance, only: [:index, :destroy]

  def index; end

  def create
    @new_list = current_user.later_lists.create(later_list_params)
    @sub_type = params[:sub_type] # alwaysの場合は、モーダル を2つ出す処理
    if @new_list.valid?
      @new_list = LaterList.new
      last_page = ((current_user.later_lists.count - 1) / 22 + 1).floor
    else
      last_page = params[:page]
    end
    @later_lists = current_user.later_lists.page(last_page).per(22)
    render 'index'
  end

  def destroy
    LaterList.find(params[:id]).destroy
    render 'index'
  end

  private

  def later_list_params
    params.require(:later_list).permit(:word)
  end

  def set_list_instance
    @new_list = LaterList.new
    @later_lists = current_user.later_lists.page(params[:page]).per(22)
  end
end
