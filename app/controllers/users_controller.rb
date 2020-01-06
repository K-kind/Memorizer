class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = '仮登録が完了しました。本登録完了のために、メールをご確認ください。' 
      log_in @user
      redirect_to @user
    else
      render 'homes/about'
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation, :user_skill_id)
  end
end
