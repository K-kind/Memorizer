require 'rails_helper'

# 問題の正解率表記、復習スタートからの流れ
RSpec.describe 'Questions', type: :system, js: true, vcr: { cassette_name: 'apis' }, retry: 3 do
  let(:user) { create(:user) }
  let(:calendar_yesterday) { user.calendars.create!(calendar_date: Time.zone.yesterday) }
  let(:calendar_today) { user.calendars.create!(calendar_date: Time.zone.today) }
  let(:word_definition_lead) { create(:word_definition, :lead) }
  let(:leraned_content_today1) do
    create(:learned_content,
           user: user,
           calendar: calendar_yesterday,
           word_definition: word_definition_lead,
           review_date: Time.zone.today)
  end
  let(:leraned_content_today2) do
    create(:learned_content,
           user: user,
           calendar: calendar_yesterday,
           word_definition: word_definition_lead,
           review_date: Time.zone.today)
  end
  let(:leraned_content_tommorow) do
    create(:learned_content,
           user: user,
           calendar: calendar_today,
           word_definition: word_definition_lead,
           review_date: Time.zone.today + 1)
  end

  before do
    create(:level)
    create(:level, :level2)
    3.times do |n|
      leraned_content_today1.questions.create!(
        question: "Learn1 Q#{n + 1}",
        answer: "lead #{n + 1}"
      )
      leraned_content_today2.questions.create!(
        question: "Learn2 Q#{n + 1}",
        answer: "long answer for lead #{n + 1}"
      )
    end
    leraned_content_tommorow.questions.create!(
      question: 'Tommorow question',
      answer: 'Tommorow answer'
    )
    actual_sign_in_as user
  end

  it 'user has questions to answer today' do
    aggregate_failures do
      expect(page).to have_content '本日の復習:0/2'
      expect(page).to have_content '本日の学習:1'
      within('.todays-menu') do
        expect(page).to have_selector 'h3:nth-child(1)', text: '本日の復習'
        expect(page).to have_selector 'ul:nth-child(2) li', text: 'Learn1 Q1'
        expect(page).to have_selector 'ul:nth-child(2) li', text: 'Learn2 Q1'
        expect(page).to have_selector 'h3:nth-child(3)', text: '本日の学習'
        expect(page).to have_selector 'ul:nth-child(4) li', text: 'Tommorow question'

        expect(page).to_not have_content '完了しました'
        expect(page).to_not have_content '復習するコンテンツがありません。'
      end
    end

    # 明日の復習予定の問題（本日の復習が残っている状態）
    click_link 'Tommorow question'
    find_link('回答する').click
    expect(page).to_not have_link('Finish')
    expect(page).to_not have_content 'No.'
    find('a', text: 'Hint').click
    expect(page).to have_selector('.question-box__hint', text: 'T******* ******')
    fill_in 'A:', with: 'Tommorow answer'
    click_button 'Submit'

    aggregate_failures do
      expect(page).to have_selector 'strong', text: 'Excellent!'
      expect(page).to have_selector '.answer-box__similarity--blue', text: '100%'
      expect(page).to_not have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to_not have_content '本日の復習は終了しました。'
    end

    click_link 'lead'
    expect(page).to have_content '次の復習まで: 1日'
    expect(page).to_not have_link 'Next'
    expect(page).to_not have_link 'Finish'
    expect(page).to_not have_content 'Again'

    # ダッシュボードから復習開始
    visit root_path
    click_on '復習スタート'
    expect(current_path).to eq question_learn_path(leraned_content_today1)
    expect(page).to have_content 'No. 1 / 2'
    expect(page).to have_link 'Finish'

    # too long answer should be invalid
    find_field('A:', match: :first).fill_in with: ('a' * 256)
    click_button 'Submit'
    expect(page).to have_selector '.error-message__list', text: '答えは255文字以内で入力してください'

    3.times do |n|
      expect(page).to have_content "Learn1 Q#{n + 1}"
      within all('.question-box')[n] do
        find('a', text: 'Hint').click
        expect(page).to have_selector('.question-box__hint', text: 'l*** *')
        fill_in 'A:', with: "lead #{n + 1}"
      end
    end
    click_button 'Submit'
    aggregate_failures do
      expect(page).to have_selector 'strong', text: 'Excellent!'
      expect(page).to have_selector '.answer-box__similarity--blue', text: '100%', count: 3
      expect(page).to have_link 'lead'
      expect(page).to have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to_not have_selector '.fas.fa-thumbs-up'
      expect(page).to_not have_content '本日の復習は終了しました。'
    end

    click_link 'lead'
    expect(page).to have_content '次の復習まで: 7日'
    expect(page).to have_link 'Next'
    expect(page).to have_link 'Finish'
    expect(page).to_not have_selector '.fas.fa-thumbs-up'
    aggregate_failures do
      check 'サイクルを進めない'
      expect(page).to have_selector('.flash__notice', text: 'この問題をもう一度同じサイクルで復習します。')
      expect(page).to have_content '次の復習まで: 1日'
      uncheck 'サイクルを進めない'
      expect(page).to have_selector('.flash__notice', text: 'この問題は次の復習サイクルに進みます。')
      expect(page).to have_content '次の復習まで: 7日'
      check 'サイクルを進めない'
      expect(page).to have_selector('.flash__notice', text: 'この問題をもう一度同じサイクルで復習します。')
      expect(page).to have_content '次の復習まで: 1日'
    end
    click_link 'Next'

    expect(page).to have_content 'No. 2 / 2'
    expect(page).to have_link 'Finish'
    3.times do |n|
      expect(page).to have_content "Learn2 Q#{n + 1}"
      within all('.question-box')[n] do
        find('a', text: 'Hint').click
        expect(page).to have_selector('.question-box__hint', text: 'l*** ****** *** **** *')
        case n
        when 0
          fill_in 'A:', with: 'long answer for lead 1'
        when 1
          fill_in 'A:', with: 'long answer '
        when 2
          fill_in 'A:', with: 'h'
        end
      end
    end
    click_button 'Submit'
    sleep(1)
    aggregate_failures do
      expect(page).to_not have_selector 'strong', text: 'Excellent!'
      sleep(2)
      expect(page).to have_selector '.answer-box__similarity--blue', text: '100%'
      expect(page).to have_selector '.answer-box__similarity--black', text: '54%'
      expect(page).to have_selector '.answer-box__similarity--red', text: '0%'
      expect(page).to have_link 'lead'
      expect(page).to_not have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to have_content '本日の復習は終了しました。'
    end

    click_link 'lead'
    expect(page).to have_content '次の復習まで: 7日'
    expect(page).to_not have_link 'Next'
    expect(page).to have_link 'Finish'

    # 明日の復習予定は2つ（元々のものと、againに指定したもの）
    visit root_path
    expect(page).to have_content '本日の復習:2/2'
    expect(page).to have_content '完了しました'
    sleep(1)
    find('.fc-title', text: 'To do: 2').click # カレンダー
    sleep(1)
    within '#calendar-show' do
      expect(page).to have_content 'Learn1 Q1'
      expect(page).to have_content 'Tommorow question'
      expect(page).to_not have_content 'Learn2 Q1'

      click_link 'Tommorow question'
    end

    # 明日の復習予定の問題（本日の復習が完了している状態）
    find_link('回答する').click
    expect(page).to_not have_link('Finish')
    expect(page).to_not have_content 'No.'
    fill_in 'A:', with: 'Tommorow answer'
    click_button 'Submit'

    aggregate_failures do
      expect(page).to_not have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to_not have_content '本日の復習は終了しました。'
    end

    click_link 'lead'
    expect(page).to have_content '次の復習まで: 1日'
    expect(page).to_not have_link 'Next'
    expect(page).to_not have_link 'Finish'
    expect(page).to_not have_content 'Again'

    # 次の日に設定
    LearnedContent.all.each do |learned_content|
      learned_content.update!(review_date: learned_content.review_date - 1)
    end
    visit root_path
    aggregate_failures do
      expect(page).to have_content '本日の復習:2/4'
      within('.todays-menu') do
        expect(page).to have_selector 'h3:nth-child(1)', text: '本日の復習'
        expect(page).to have_selector 'ul:nth-child(2) li', text: 'Learn1 Q1'
        expect(page).to have_selector 'ul:nth-child(2) li', text: 'Tommorow question'
      end
    end
  end
end
