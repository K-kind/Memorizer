class HomesController < ApplicationController
  protect_from_forgery except: :calendar
  before_action :logged_in_user, only: [:top, :calendar]
  before_action :confirm_user_skill, only: [:top]
  before_action :reset_question_back, only: [:top]
  before_action :no_always_dictionary, only: [:about]

  def top
    current_user.calendars.find_or_create_by!(calendar_date: Time.zone.today)
    @calendars = current_user.calendars
    @notice = Notice.last
  end

  def about
    @notice = Notice.last
  end

  def calendar
    date = params[:date]
    parsed_date = Time.zone.parse(date).to_date
    @calendar = current_user.calendars.find_by(calendar_date: parsed_date)
    respond_to do |format|
      format.js
    end
  end

  def always_dictionary; end

  def help; end
end
