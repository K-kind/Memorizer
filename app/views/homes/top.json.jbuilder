json.array!(@calendars) do |calendar|
  if calendar.calendar_date < Time.zone.today
    new_count = calendar.learned_contents.count
    review_count = calendar.review_histories.count
    if new_count != 0 || review_count != 0
      json.title "学習: #{new_count}\n復習: #{review_count}"
      json.start calendar.calendar_date
      json.url calendar_url(calendar, format: :js)
    end
  elsif calendar.calendar_date == Time.zone.today
    json.title "復習予定: #{current_user.learned_contents.to_review_today.count}\n学習: #{calendar.learned_contents.count}\n復習: #{calendar.review_histories.count}"
    json.start calendar.calendar_date
    json.url calendar_url(calendar, format: :js)
  elsif (review_count = current_user.learned_contents.to_review_this_day(calendar.calendar_date).count) != 0
    json.title "復習予定: #{review_count}"
    json.start calendar.calendar_date
    json.url calendar_url(calendar, format: :js)
  end
end
