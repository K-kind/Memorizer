class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    respond_to do |format|
      if user&.authenticate(params[:password])
        log_in user
        params[:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = 'ログインしました。'
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

  def auth_success
    auth = request.env['omniauth.auth']
    user = User.find_or_create_from_auth(auth)
    log_in user
    if user.activated?
      flash[:success] = 'ログインしました。'
    else
      user.activate
      flash[:success] = 'アカウント認証に成功しました。'
    end
    redirect_back_or root_url
  end

  def auth_failure
    flash[:danger] = 'アカウント認証に失敗しました。'
    redirect_to about_url
  end
end
