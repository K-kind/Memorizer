class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'ログインが必要です' unless session[:forwarding_url] == root_url
    redirect_to about_url
  end
end
