class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    respond_to do |format|
      if user&.authenticate(params[:password])
        if user.activated?
          log_in user
          params[:remember_me] == '1' ? remember(user) : forget(user)
          flash[:notice] = 'ログインしました。'
          format.html { redirect_back_or root_url }
        else
          message = 'アカウントが有効化されていません。'
          message += '仮登録確認メールをご確認ください。'
          flash[:danger] = message
          format.html { redirect_to about_url }
        end
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
    if session[:sns_remember]
      remember(user)
      session[:sns_remember] = nil
    end
    if user.activated?
      flash[:notice] = 'ログインしました。'
    else
      user.activate
      flash[:notice] = 'アカウント認証に成功しました。'
    end
    redirect_back_or root_url
  end

  def auth_failure
    flash[:danger] = 'アカウント認証に失敗しました。'
    redirect_to about_url
  end

  # SNSログイン用のremember_meチェック
  def sns_remember
    session[:sns_remember] = params[:sns_remember] == '1' ? true : nil
  end

  def test_login
    number = (Time.zone.now.min / 10).floor # 分の10の位を取得
    user = User.find_by(email: "test_user#{number}@memorizer.tech")
    log_in user
    flash[:notice] = "テストユーザー#{number}でログインしました。データは1時間ごとにリセットされます。"
    redirect_back_or root_url
  end
end
