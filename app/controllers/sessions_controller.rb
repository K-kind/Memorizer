class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    respond_to do |format|
      if user&.authenticate(params[:password])
        log_in user
        params[:remember_me] == '1' ? remember(user) : forget(user)
        format.html { redirect_back_or root_url }
      else
        @error_message = 'メールアドレスとパスワードの組み合わせが不正です。'
        format.js { render 'error' }
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to about_url
  end

  def auth_failure
  end
end
