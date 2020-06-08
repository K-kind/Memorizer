require 'rails_helper'

RSpec.describe 'Level', type: :system, js: true, vcr: { cassette_name: 'apis' }, retry: 3 do
  include LevelSet
  let(:user_skill) { create(:user_skill) }
  let(:user) { create(:user, user_skill: user_skill) }
  let(:other_user) { create(:user, user_skill: user_skill) }
  let(:word_category) { create(:word_category) }
  let(:word_definition) { create(:word_definition) }
  let(:calendar) { create(:calendar) }

  before do
    4.times do |n|
      u = n == 3 ? other_user : user
      learned_content = create(:learned_content,
                               user: u,
                               word_definition: word_definition,
                               word_category: word_category,
                               calendar: calendar,
                               review_date: Time.zone.today)
      case n
      when 0
        question = 'Q for 90%'
        answer = 'a' * 10
      when 1
        question = 'Q for 50%'
        answer = 'a' * 10
      when 2
        question = 'Q for 49%'
        answer = 'a' * 100
      when 3
        question = 'Q of other_user'
        answer = 'a' * 10
      end
      learned_content.questions.create!(
        question: question,
        answer: answer
      )
    end
    create(:level)
    actual_sign_in_as user
  end

  it 'is calculated in each situations' do
    # 新規学習 5exp
    set_exp(user: user, exp: 2)
    visit new_learn_path
    perform_enqueued_jobs do
      fill_in 'word', with: 'lead'
      click_button 'consult-submit'
      find('#learned_content_content').set('I learned the word star.')
      fill_in 'Question 1', with: 'Q about lead'
      fill_in 'Answer 1', with: 'The answer is lead'
    end

    expect {
      click_button 'Save'
      expect(page).to have_selector('.flash__notice', text: '学習が記録されました')
      expect(page).to have_selector('.flash__level_up', text: 'Level UP! Lv.2')
    }.to change { user.reload.level }.by(1).and \
      change { user.reload.exp }.by(5)

    # 自分の問題
    visit root_path

    # 90%以上 4exp
    set_exp(user: user, exp: 3)
    click_link '復習スタート'
    fill_in 'A:', with: 'a' * 9 + 'b'
    expect {
      click_button 'Submit'
      expect(page).to have_selector('.flash__level_up', text: 'Level UP! Lv.2')
      expect(page).to have_selector('.answer-box__similarity--blue', text: '90%')
    }.to change { user.reload.level }.by(1).and \
      change { user.reload.exp }.by(4)

    # 50%以上 3exp
    set_exp(user: user, exp: 4)
    click_link 'Next'
    fill_in 'A:', with: 'a' * 5 + 'b' * 5
    expect {
      click_button 'Submit'
      expect(page).to have_selector('.flash__level_up', text: 'Level UP! Lv.2')
      expect(page).to have_selector('.answer-box__similarity--black', text: '50%')
    }.to change { user.reload.level }.by(1).and \
      change { user.reload.exp }.by(3)

    # 49%以下 2exp
    set_exp(user: user, exp: 5)
    click_link 'Next'
    fill_in 'A:', with: 'a' * 49 + 'b' * 51
    expect {
      click_button 'Submit'
      expect(page).to have_selector('.flash__level_up', text: 'Level UP! Lv.2')
      expect(page).to have_selector('.answer-box__similarity--red', text: '49%')
    }.to change { user.reload.level }.by(1).and \
      change { user.reload.exp }.by(2)

    # みんなの問題 1exp
    set_exp(user: user, exp: 6)
    visit communities_questions_path
    find('a', text: 'Q of other_user').click
    find('a', text: '回答する').click
    fill_in 'A:', with: 'a' * 9 + 'b'
    expect {
      click_button 'Submit'
      expect(page).to have_selector('.flash__level_up', text: 'Level UP! Lv.2')
      expect(page).to have_selector('.answer-box__similarity--blue', text: '90%')
    }.to change { user.reload.level }.by(1).and \
      change { user.reload.exp }.by(1)
    click_link 'Download'
    expect(page).to have_selector('.flash__notice', text: '学習コンテンツをダウンロードしました')

    # 本日の復習ではない問題 0exp
    set_exp(user: user, exp: 6)
    visit learns_path
    find('a', text: 'Q for 90%').click
    find('a', text: '回答する').click
    fill_in 'A:', with: 'a' * 10
    expect {
      click_button 'Submit'
      expect(page).to_not have_selector('.flash__level_up', text: 'Level UP! Lv.2')
      expect(page).to have_selector('.answer-box__similarity--blue', text: '100%')
    }.to change { user.reload.level }.by(0).and \
      change { user.reload.exp }.by(0)

    # 正解率モーダル
    visit learns_path
    # ダウンロードしたばかりの問題
    within 'tbody tr:first-child' do
      expect(page).to have_content 'Q of other_user'
      find('td:nth-child(2) ', text: '0').click
    end
    expect(page).to have_selector '#question-modal'
    expect(page).to_not have_content '復習1回目: 90%'
    find('.login-form__closer').click
    wait_for_ajax

    # 作成したばかりの問題
    within 'tbody tr:nth-child(2)' do
      expect(page).to have_content 'Q about lead'
      find('td:nth-child(2) ', text: '0').click
    end
    expect(page).to have_selector '#question-modal'
    expect(page).to_not have_content '復習1回目:'
    find('.login-form__closer').click
    wait_for_ajax

    # 49%の正解率
    within 'tbody tr:nth-child(3)' do
      expect(page).to have_content 'Q for 49%'
      find('td:nth-child(2) ', text: '1').click
    end
    expect(page).to have_selector '#question-modal'
    expect(page).to have_content '復習1回目: 49%'
    find('.login-form__closer').click
    wait_for_ajax

    # 50%の正解率
    within 'tbody tr:nth-child(4)' do
      expect(page).to have_content 'Q for 50%'
      find('td:nth-child(2) ', text: '1').click
    end
    expect(page).to have_selector '#question-modal'
    expect(page).to have_content '復習1回目: 50%'
    find('.login-form__closer').click
    wait_for_ajax

    # 90%の正解率
    within 'tbody tr:nth-child(5)' do
      expect(page).to have_content 'Q for 90%'
      find('td:nth-child(2) ', text: '1').click
    end
    expect(page).to have_selector '#question-modal'
    expect(page).to have_content '復習1回目: 90%'
    find('.login-form__closer').click
  end
end
