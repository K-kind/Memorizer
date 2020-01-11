json.array!(@calendars) do |calendar|
  if calendar.calendar_date < Time.zone.today
    json.title "新規学習数: #{calendar.learned_contents.count}\n復習した数: #{calendar.review_histories.count}"
  elsif calendar.calendar_date == Time.zone.today
    json.title "復習すべき数: #{current_user.learned_contents.to_review_today.count}\n新規学習数: #{calendar.learned_contents.count}\n復習した数: #{calendar.review_histories.count}"
  else
    json.title "復習すべき数: #{current_user.learned_contents.to_review_this_day(calendar.calendar_date).count}"
  end
  json.start calendar.calendar_date
  # json.url calendar_url(calendar, format: :js)
end