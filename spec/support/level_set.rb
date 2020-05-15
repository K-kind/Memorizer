module LevelSet
  def set_exp(user:, exp:)
    user.update!(level_id: 1, exp: exp)
  end
end
