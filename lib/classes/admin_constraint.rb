class AdminConstraint
  def matches?(request)
    return false unless request.session[:admin_id]

    Admin.find request.session[:admin_id]
  end
end
