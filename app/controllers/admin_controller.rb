class AdminController < ApplicationController
  include Admin::SessionsHelper
  before_action :logged_in_admin

  private

  def logged_in_admin
    return if admin_logged_in?

    flash[:danger] = '管理者ログインが必要です'
    redirect_to admin_login_url
  end
end
