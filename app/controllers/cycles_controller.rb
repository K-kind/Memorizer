class CyclesController < ApplicationController
  before_action :logged_in_user

  def set
    if current_user.update(cycle_params)
      @message = '復習サイクルを更新しました。'
    end
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
    [1, 7, 16, 35, 62].each_with_index do |cycle, index|
      new_cycle = current_user.cycles.find_by(times: index)
      new_cycle.update!(cycle: cycle)
    end
    current_user.cycles.where('times > 4').destroy_all
    @message = 'サイクルをデフォルトに設定しました。'
    render 'set'
  end

  private

  def cycle_params
    params.require(:user).permit(cycles_attributes: [:cycle, :times, :id])
  end
end
