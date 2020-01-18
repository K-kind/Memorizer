class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user
      user.create_reset_digest
      user.send_password_reset_email
      flash[:notice] = 'パスワード再設定用のメールを送信しました。'
      respond_to do |format|
        format.html { redirect_to about_url }
      end
    else
      @message = 'メールアドレスが見つかりません。'
      render 'error'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'error'
    elsif @user.update(user_params)
      log_in @user
      flash[:notice] = 'パスワードが再設定されました。'
      @user.update(reset_digest: nil)
      respond_to do |format|
        format.html { redirect_to root_url }
      end
    else
      render 'error'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = '無効なリンクです。'
    redirect_to about_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'パスワードリセットリンクが有効期限切れです。'
    redirect_to about_url
  end
end
