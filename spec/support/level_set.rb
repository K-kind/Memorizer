module LevelSet
  def set_exp(user:, exp:)
    user.update!(level: 1, exp: exp)
  end
end
