module LoginSupport
  def sign_in_as(user)
    return unless user.valid?

    page.set_rack_session(user_id: user.id)
  end

  def actual_sign_in_as(user)
    visit about_path
    click_on 'ログイン'
    fill_in 'email-form', with: user.email
    fill_in 'password', with: user.password
    click_button 'ログイン'
  end
end
