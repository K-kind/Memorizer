# json.title '今日'
# # json.title "復習すべき数: #{contents_to_review_today}\n新規学習数: #{learned_contents_today}\n復習した数: #{reviewed_count_today}"
# json.start Time.zone.today

json.array!(@calendars) do |calendar|
  if calendar.calendar_date < Time.zone.today
    json.title "新規学習数: #{calendar.learned_contents.count}\n復習した数: #{calendar.review_histories.count}"
    json.start calendar.calendar_date
  elsif calendar.calendar_date > Time.zone.today
    json.title "復習すべき数: #{current_user.learned_contents.to_review_this_day(calendar.calendar_date).count}"
    json.start calendar.calendar_date
  end
  json.title "復習すべき数: #{contents_to_review_today}\n新規学習数: #{learned_contents_today}\n復習した数: #{reviewed_count_today}"
  json.start Time.zone.today
  # json.url calendar_url(calendar, format: :js)
end