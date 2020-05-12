module LoginSupport
  def sign_in_as(user)
    return unless user.valid?

    page.set_rack_session(user_id: user.id)
  end
end
