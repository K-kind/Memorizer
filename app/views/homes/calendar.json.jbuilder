json.array!(@calendars) do |calendar|
  date = calendar.calendar_date
  today = Time.zone.today

  if date < today
    new_count = calendar.learned_contents.count
    review_count = calendar.review_histories.count
    if new_count != 0 || review_count != 0
      title = "学習: #{new_count}\n復習: #{review_count}"
    end
  elsif date == today
    title = "復習予定: #{current_user.learned_contents.to_review_today.count}\n学習: #{calendar.learned_contents.count}\n復習: #{calendar.review_histories.count}"
  else
    review_count = current_user.learned_contents.to_review_this_day(calendar.calendar_date).count
    title = "復習予定: #{review_count}" unless review_count == 0
  end
  next unless title

  json.title title
  json.start date
  json.calendar_id calendar.id
end
