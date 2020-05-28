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
    @reviewed_count_today = reviewed_count_today
    @learned_contents_today = current_user.calendars
                                          .find_by(calendar_date: Time.zone.today)
                                          .learned_contents
                                          .for_q_and_words
    @contents_to_review_today = current_user.learned_contents
                                            .to_review_today
                                            .for_q_and_words
  end

  def calendar
    start_date = params[:start]
    end_date = params[:end]
    @calendars = current_user.calendars
                             .between_dates(start_date, end_date)
                             .with_contents_and_reviews(current_user.id)
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
