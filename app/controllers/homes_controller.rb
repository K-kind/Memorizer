class HomesController < ApplicationController
  def top
  end

  def about
    @user = User.new
  end
end
