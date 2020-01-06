class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?

    flash[:danger] = 'ログインが必要です'
    redirect_to about_url
  end
end
