json.array!(@calendars) do |calendar|
  date = calendar.calendar_date
  today = Time.zone.today

  if date < today
    new_count = calendar.contents_count
    review_count = calendar.reviews_count
    title = "Learn: #{new_count}\nReview: #{review_count}" \
      if new_count != 0 || review_count != 0
  elsif date == today
    to_do = current_user.learned_contents.to_review_today.count
    learn = calendar.contents_count
    review = calendar.reviews_count
    title = "To do: #{to_do}\nLearn: #{learn}\nReview: #{review}"
  else
    to_do_count = calendar.to_do_count
    title = "To do: #{to_do_count}" unless to_do_count.zero?
  end
  next unless title

  json.title title
  json.start date
  json.calendar_id calendar.id
end
