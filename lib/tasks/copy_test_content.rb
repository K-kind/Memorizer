# テスト管理ユーザーの直近7問や他データをコピー
test_admin = User.find_by(is_test_user: true, name: 'テスト管理ユーザー')
User.where('is_test_user = ? AND name != ?', true, 'テスト管理ユーザー').each do |user|
  test_admin.learned_contents.each.with_index(1) do |original_content, index|
    # 日付は6, 7問目をデフォルト（昨日作って今日復習）にする
    learned_content = user.learned_contents.create!(
      word_definition_id: original_content.word_definition_id,
      word_category_id: original_content.word_category_id,
      calendar_id: user.calendars.find_or_create_by!(calendar_date: Time.zone.today - 1),
      created_at: Time.zone.today - 1
      is_public: false,
      is_test: true,
      content: original_content.content,
      review_date: Time.zone.today,
    )
    original_content.duplicate_children_to(learned_content)

    # 6, 7問目以外の日付を設定し直す
    created_ndays_ago, reviewed_ndays_ago, ratio =
      case index
      when 1
        [8, 7, 10]
      when 2, 3
        [5, 4, 25]
      when 4
        [3, 2, 40]
      when 5
        [2, 1, 50]
      end
    if index.in?(1..5)
      learned_content.update!(
        calendar_id: user.calendars.find_or_create_by!(calendar_date: Time.zone.today - created_ndays_ago),
        created_at: Time.zone.today - created_ndays_ago,
        review_date: Time.zone.today + 7 - reviewed_ndays_ago
      )
      learned_content.review_histories.create(
        similarity_ratio: ratio,
        calendar_id: user.calendars.find_or_create_by!(calendar_date: Time.zone.today - reviewed_ndays_ago),
        created_at: Time.zone.today - reviewed_ndays_ago
      )
    end

    # 復習予定のカレンダーだけ作っていなかった
    user.calendars.find_or_create_by!(calendar_date: learned_content.review_date)
  end

  # later_list
  user.later_lists.destroy_all
  test_admin.consulted_words.each do |later_list|
    user.later_lists.create!(
      word: later_list.word,
      created_at: Time.zone.yesterday
    )
  end

  # template
  user.learn_templates.last.update!(
    content: test_admin.learn_templates.last.content,
    updated_at: Time.zone.yesterday
  )

  # consulted_word
  test_admin.consulted_words.where('created_at > ?', Time.zone.yesterday).each do |consulted_word|
    user.consulted_words.create!(
      word_definition_id: consulted_word.word_definition_id,
      created_at: Time.zone.yesterday
    )
  end

  # contact
  user.contacts.destroy_all
  test_admin.contacts.each do |contact|
    user.contacts.create!(
      comment: contact.comment,
      from_admin: contact.from_admin,
      created_at: Time.zone.yesterday
    )
  end
end
