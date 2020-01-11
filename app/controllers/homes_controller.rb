class HomesController < ApplicationController
  protect_from_forgery except: :calendar

  def top
    @calendars = current_user.calendars
  end

  def about
  end

  def calendar
    respond_to do |format|
      format.js
    end
  end
end
