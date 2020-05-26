module LoginSupport
  def sign_in_as(user)
    return unless user.valid?

    page.set_rack_session(user_id: user.id)
  end

  def actual_sign_in_as(user)
    visit about_path
    find('#login-link').click
    fill_in 'email-form', with: user.email
    fill_in 'password', with: user.password
    click_button 'ログイン'
    wait_for_css_appear('.flash__notice')
  end
end
