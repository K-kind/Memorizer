class HomesController < ApplicationController
  protect_from_forgery except: :calendar

  def top
    @calendars = current_user.calendars
  end

  def about
  end

  def calendar
    date = params[:date]
    parsed_date = Time.zone.parse(date).to_date
    @calendar = current_user.calendars.find_by(calendar_date: parsed_date)
    respond_to do |format|
      format.js
    end
  end
end
