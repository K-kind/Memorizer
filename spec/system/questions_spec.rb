require 'rails_helper'

RSpec.describe 'Questions', type: :system, js: true, vcr: { cassette_name: 'apis' } do
  let(:user) { create(:user) }
  let(:calendar_yesterday) { user.calendars.create!(calendar_date: Time.zone.yesterday) }
  let(:calendar_today) { user.calendars.create!(calendar_date: Time.zone.today) }
  let(:word_definition_lead) { create(:word_definition, :lead) }
  let(:leraned_content_today1) do
    create(:learned_content,
           user: user,
           calendar: calendar_yesterday,
           word_definition: word_definition_lead,
           till_next_review: 0)
  end
  let(:leraned_content_today2) do
    create(:learned_content,
           user: user,
           calendar: calendar_yesterday,
           word_definition: word_definition_lead,
           till_next_review: 0)
  end
  let(:leraned_content_tommorow) do
    create(:learned_content,
           user: user,
           calendar: calendar_today,
           word_definition: word_definition_lead,
           till_next_review: 1)
  end
  before do
    Level.create!(threshold: 7)
    Level.create!(threshold: 17)
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
      expect(page).to have_content '本日の復習: 0/2'
      expect(page).to have_content '本日の学習: 1'
      expect(page).to have_selector 'h3:nth-child(1)', text: '本日の復習'
      expect(page).to have_selector 'li:nth-child(2)', text: 'Learn1 Q1'
      expect(page).to have_selector 'li:nth-child(3)', text: 'Learn2 Q1'
      expect(page).to have_selector 'h3:nth-child(4)', text: '本日の学習'
      expect(page).to have_selector 'li:nth-child(5)', text: 'Tommorow question'

      expect(page).to_not have_content '復習完了!'
      expect(page).to_not have_content '復習するコンテンツがありません。'
    end

    # 明日の復習予定の問題（本日の復習が残っている状態）
    click_link 'Tommorow question'
    find_link('Question').click
    expect(page).to_not have_link('Finish')
    expect(page).to_not have_content 'No.'
    fill_in 'A:', with: 'Tommorow answer'
    click_button 'Submit'

    aggregate_failures do
      expect(page).to have_selector 'strong', text: 'Excellent!'
      expect(page).to have_selector '.answer-box__similarity--blue', text: '100%'
      expect(page).to_not have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to_not have_content '本日の復習は終了しました。'
    end

    click_link '"lead"'
    expect(page).to have_content 'Until next review: 1 day'
    expect(page).to_not have_link 'Next'
    expect(page).to_not have_link 'Finish'
    expect(page).to_not have_content 'Again'

    # ダッシュボードから復習開始
    visit root_path
    click_on '復習スタート'
    expect(current_path).to eq question_learn_path(leraned_content_today1)
    expect(page).to have_content 'No. 1 / 2'
    expect(page).to have_link 'Finish'

    # too long answer should be valid
    find_field('A:', match: :first).fill_in with: ('a' * 256)
    click_button 'Submit'
    expect(page).to have_selector '.error-message__list', text: '答えは255文字以内で入力してください'

    3.times do |n|
      expect(page).to have_content "Learn1 Q#{n + 1}"
      within all('.question-box')[n] do
        fill_in 'A:', with: "lead #{n + 1}"
      end
    end
    click_button 'Submit'
    aggregate_failures do
      expect(page).to have_selector 'strong', text: 'Excellent!'
      expect(page).to have_selector '.answer-box__similarity--blue', text: '100%', count: 3
      expect(page).to have_link '"lead"'
      expect(page).to have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to_not have_selector '.fas.fa-thumbs-up'
      expect(page).to_not have_content '本日の復習は終了しました。'
    end

    click_link '"lead"'
    expect(page).to have_content 'Until next review: 7 days'
    expect(page).to have_link 'Next'
    expect(page).to have_link 'Finish'
    expect(page).to_not have_selector '.fas.fa-thumbs-up'
    aggregate_failures do
      check 'Again:'
      expect(page).to have_selector('.flash__notice', text: 'この問題をもう一度同じサイクルで復習します。')
      expect(page).to have_content 'Until next review: 1 day'
      uncheck 'Again:'
      expect(page).to have_selector('.flash__notice', text: 'この問題は次の復習サイクルに進みます。')
      expect(page).to have_content 'Until next review: 7 days'
      check 'Again:'
      expect(page).to have_selector('.flash__notice', text: 'この問題をもう一度同じサイクルで復習します。')
      expect(page).to have_content 'Until next review: 1 day'
    end
    click_link 'Next'

    expect(page).to have_content 'No. 2 / 2'
    expect(page).to have_link 'Finish'
    3.times do |n|
      expect(page).to have_content "Learn2 Q#{n + 1}"
      within all('.question-box')[n] do
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
    aggregate_failures do
      expect(page).to_not have_selector 'strong', text: 'Excellent!'
      expect(page).to have_selector '.answer-box__similarity--blue', text: '100%'
      expect(page).to have_selector '.answer-box__similarity--black', text: '54%'
      expect(page).to have_selector '.answer-box__similarity--red', text: '0%'
      expect(page).to have_link '"lead"'
      expect(page).to_not have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to have_content '本日の復習は終了しました。'
    end

    click_link '"lead"'
    expect(page).to have_content 'Until next review: 7 days'
    expect(page).to_not have_link 'Next'
    expect(page).to have_link 'Finish'

    # 明日の復習予定は2つ（元々のものと、againに指定したもの）
    visit root_path
    expect(page).to have_content '本日の復習: 2/2'
    expect(page).to have_content '復習完了!'
    click_on '復習予定: 2' # カレンダー
    within '#calendar-show' do
      expect(page).to have_content 'Learn1 Q1'
      expect(page).to have_content 'Tommorow question'
      expect(page).to_not have_content 'Learn2 Q1'

      click_link 'Tommorow question'
    end

    # 明日の復習予定の問題（本日の復習が完了している状態）
    find_link('Question').click
    expect(page).to_not have_link('Finish')
    expect(page).to_not have_content 'No.'
    fill_in 'A:', with: 'Tommorow answer'
    click_button 'Submit'

    aggregate_failures do
      expect(page).to_not have_link 'Next'
      expect(page).to have_link 'Finish'
      expect(page).to_not have_content '本日の復習は終了しました。'
    end

    click_link '"lead"'
    expect(page).to have_content 'Until next review: 1 day'
    expect(page).to_not have_link 'Next'
    expect(page).to_not have_link 'Finish'
    expect(page).to_not have_content 'Again'
  end
end
