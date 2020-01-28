class CyclesController < ApplicationController
  before_action :logged_in_user

  def set
    @message = '復習サイクルを更新しました。' if current_user.update(cycle_params)
  end

  def new
    unless params[:cancel]
      new_times = current_user.cycles.count
      current_user.cycles.build(times: new_times)
      @added = true
    end
    render 'set'
  end

  def destroy
    Cycle.find(params[:id]).destroy
    @message = '最後のサイクルを削除しました。'
    render 'set'
  end

  def default
    current_user.rollback_to_default_cycle
    @message = 'サイクルをデフォルトに設定しました。'
    render 'set'
  end

  private

  def cycle_params
    params.require(:user).permit(cycles_attributes: [:cycle, :times, :id])
  end
end
