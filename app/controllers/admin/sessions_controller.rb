class Admin::SessionsController < AdminController
  def new; end

  def create
    admin = Admin.find_by(email: params[:email].downcase)
    if admin&.authenticate(params[:password])
      admin_log_in admin
      redirect_to admin_users_url
    else
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせが正しくありません'
      render 'new'
    end
  end

  def destroy
    admin_log_out
    redirect_to admin_login_url
  end
end
