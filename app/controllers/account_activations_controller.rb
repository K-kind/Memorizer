class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = '本登録が完了しました。'
      redirect_to user
    else
      flash[:danger] = '有効化リンクが無効です。'
      redirect_to about_url
    end
  end
end
