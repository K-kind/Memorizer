class UsersController < ApplicationController
  before_action :logged_in_user, except: [:create]

  def create
    @new_user = User.new(user_params)
    respond_to do |format|
      if @new_user.save
        @new_user.send_activation_email
        @new_user.send_notification_email_to_admin
        @new_user.notifications.create(to_admin: true, action: 1)
        @new_user.set_default_template
        flash[:notice] = '仮登録完了メールを送信しました。ご確認ください。'
        format.html { redirect_to about_url }
      else
        format.js { render 'signup_error' }
      end
    end
  end

  def show
    @user_skills = UserSkill.all
    @active_users = User.where(activated: true, is_test_user: false)
    @prev = params[:prev].to_i
    day = @prev ? Time.zone.today.prev_month(@prev) : Time.zone.today
    @new_learn_chart = current_user.calendars.learn_chart('learned_contents', day)
    @reviewed_chart = current_user.calendars.learn_chart('review_histories', day)
    @learn_template = current_user.learn_templates.last
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        flash[:notice] = 'ユーザー情報を更新しました'
        format.html { redirect_to user_url }
      else
        @user_skills = UserSkill.all
        format.js
      end
    end
  end

  def destroy
    user = current_user
    log_out
    user.destroy
    redirect_to about_url
  end

  def user_skill
    @user_skills = UserSkill.all
  end

  def set_user_skill
    current_user.update!(user_skill_id: params[:user_skill_id])
    @message = '登録が完了しました。'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_skill_id)
  end
end
