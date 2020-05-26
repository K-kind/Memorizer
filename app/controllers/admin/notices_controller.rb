class Admin::NoticesController < AdminController
  def index
    # ユーザーページにはlastでid検索するため、idでorder
    @notices = Notice.order(id: :desc).page(params[:page]).per(6)
    @new_notice = Notice.new
  end

  def create
    @new_notice = Notice.new(notice_params)
    @new_notice.set_expiration
    if @new_notice.save
      flash[:notice] = 'お知らせを発行しました。'
      redirect_to admin_notices_path
    else
      @notices = Notice.order(id: :desc).page(params[:page]).per(6)
      render 'index'
    end
  end

  def destroy
    notice = Notice.find(params[:id])
    notice.destroy
    flash[:notice] = 'お知らせを削除しました。'
    redirect_to admin_notices_path
  end

  private

  def notice_params
    params.require(:notice).permit(:content, :notice_type, :year, :month, :day, :oclock)
  end
end
