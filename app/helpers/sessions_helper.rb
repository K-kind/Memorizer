module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def test_log_in(user)
    user.set_test_logged_in
    user.reset_test_data_now_or(30.minutes)
    session[:test_user_id] = user.test_logged_in_by
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      return unless user&.authenticated?(:remember, cookies[:remember_token])

      log_in user
      @current_user = user
    elsif (test_user_id = session[:test_user_id])
      @current_user ||= User.find_by(test_logged_in_by: test_user_id)
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    if @current_user.test_logged_in_by
      session.delete(:test_user_id)
      @current_user.reset_test_data_now_or(nil)
    else
      forget(@current_user)
      session.delete(:user_id)
    end
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
