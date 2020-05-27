class HomesController < ApplicationController
  include HomesHelper
  protect_from_forgery except: :date
  before_action :logged_in_user, only: [:top, :calendar, :date]
  before_action :confirm_user_skill, only: [:top]
  before_action :reset_question_back, only: [:top]
  before_action :no_always_dictionary, only: [:about]

  def top
    current_user.calendars.find_or_create_by!(calendar_date: Time.zone.today)
    @notice = Notice.last
    @learned_contents_today = learned_contents_today
    @reviewed_count_today = reviewed_count_today
    @contents_to_review_today = contents_to_review_today
  end

  def calendar
    @calendars = current_user.calendars.a_month_old
  end

  def about
    @notice = Notice.last
  end

  def date
    calendar = Calendar.find(params[:id])
    render partial: 'calendar_show', locals: { calendar: calendar }
  end

  def always_dictionary; end

  def help; end
end
