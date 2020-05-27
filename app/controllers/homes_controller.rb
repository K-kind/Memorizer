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
    @learned_contents_today =
      current_user.calendars
                  .find_by(calendar_date: Time.zone.today)
                  .learned_contents
                  .includes([:word_definition,
                             :questions,
                             { related_words: :word_definition }])
    @contents_to_review_today =
      current_user.learned_contents
                  .to_review_today
                  .includes([:word_definition,
                             :questions,
                             { related_words: :word_definition }])
  end

  def calendar
    @calendars =
      current_user.calendars
                  .a_month_old
                  .left_joins(:learned_contents)
                  .joins(
                    'LEFT OUTER JOIN learned_contents AS to_do_contents
                    ON to_do_contents.review_date = calendars.calendar_date'
                  )
                  .left_joins(:review_histories)
                  .select(
                    'calendars.id,
                    calendars.calendar_date,
                    COUNT(distinct learned_contents.id) AS contents_count,
                    COUNT(distinct to_do_contents.id) AS to_do_count,
                    COUNT(distinct review_histories.id) AS reviews_count'
                  ).group(:id)
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
