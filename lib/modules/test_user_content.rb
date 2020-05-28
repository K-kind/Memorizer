module TestUserContent
  def add_test_user
    test_user_id = where(is_test_user: true).count - 1 # test_adminの分
    create!(
      name: "テストユーザー#{test_user_id}",
      email: "test_user#{test_user_id}@memorizer.tech",
      password: Rails.application.credentials.dig(:seed, :test_password),
      is_test_user: true,
      user_skill_id: UserSkill.fifth.id
    ) # test_logged_in_atは下のreset_test_contentで初期値入力
  end

  def reset_test_content
    # テスト管理ユーザーの直近7問や他データをコピー
    test_admin_email = Rails.application.credentials.dig(:seed, :test_admin_email)
    test_admin = User.find_by(email: test_admin_email)
    learned_contents.destroy_all
    calendars.destroy_all
    contents_to_copy = test_admin.learned_contents.last(7)
    raise 'lack of test admin contents' unless contents_to_copy.count == 7
    today = Time.zone.today
    yesterday = today - 1

    contents_to_copy.each.with_index(1) do |original_content, index|
      learned_content = learned_contents.create!(
        word_definition_id: original_content.word_definition_id,
        word_category_id: original_content.word_category_id,
        calendar_id: calendars.find_or_create_by!(calendar_date: yesterday).id,
        created_at: yesterday,
        is_public: false,
        is_test: true,
        content: original_content.content,
        review_date: today
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
          calendar_id: calendars.find_or_create_by!(calendar_date: today - created_ndays_ago).id,
          created_at: today - created_ndays_ago,
          review_date: today + 7 - reviewed_ndays_ago
        )
        learned_content.review_histories.create(
          similarity_ratio: ratio,
          calendar_id: calendars.find_or_create_by!(calendar_date: today - reviewed_ndays_ago).id,
          created_at: today - reviewed_ndays_ago
        )
      end

      # 復習予定のカレンダー
      calendars.find_or_create_by!(calendar_date: learned_content.review_date)
    end

    # カレンダーは、日付を古くしておく
    calendars.update_all(created_at: yesterday)

    # later_list
    later_lists.destroy_all
    test_admin.later_lists.each do |later_list|
      later_lists.create!(
        word: later_list.word,
        created_at: yesterday
      )
    end

    # template
    learn_templates.last.update(
      content: test_admin.learn_templates.last.content,
      updated_at: yesterday
    )

    # consulted_word
    consulted_words.destroy_all
    test_admin.consulted_words.each do |consulted_word|
      consulted_words.create!(
        word_definition_id: consulted_word.word_definition_id,
        created_at: yesterday
      )
    end

    # contact
    contacts.destroy_all
    test_admin.contacts.each do |contact|
      contacts.create!(
        comment: contact.comment,
        from_admin: contact.from_admin,
        created_at: yesterday
      )
    end

    # notification
    notifications.destroy_all
    notifications.create!

    # test_logged_in_at
    update!(test_logged_in_at: Time.zone.now)
  end
end
