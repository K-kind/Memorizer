require 'rails_helper'

# 画像は含まないコンテンツをダウンロードするテスト
RSpec.describe 'import contents', type: :system, js: true, vcr: { cassette_name: 'apis' } do
  let(:owner) { create(:user, :skill_900) }
  let(:user) { create(:user) }
  let(:calendar) { owner.calendars.create!(calendar_date: Time.zone.today) }
  let(:word_definition_lead) { create(:word_definition, :lead) }
  let(:word_definition_star) { create(:word_definition, :star) }
  let(:learned_content) do
    create(:learned_content,
           user: owner,
           calendar: calendar,
           word_definition: word_definition_lead,
           review_date: Time.zone.today)
  end

  before do
    create(:level)
    learned_content.questions.create!(
      question: 'Q about lead',
      answer: 'lead'
    )
    learned_content.related_words.create!(
      word_definition: word_definition_star
    )
    actual_sign_in_as user
  end

  it 'community questions can be imported' do
    expect(page).to have_content '本日の復習:0/0'
    expect(page).to have_content '本日の学習:0'
    expect(page).to_not have_content 'Q about lead'
    find('.header-right__toggler--community').click
    find('.community-menu__list', text: '問題を探す').click

    expect(page).to have_content 'Q about lead'
    expect(page).to have_content 'TOEIC900点相当'
    within 'tbody tr:first-child' do # いいね数
      expect(page).to have_selector('td:nth-child(3)', text: '0')
    end

    click_link 'Q about lead'
    expect(page).to_not have_selector('a', text: 'Review')
    click_link 'Question'

    expect(page).to have_link('Back')
    fill_in 'A:', with: 'lead'
    click_button 'Submit'

    # content can be favorited
    expect(page).to have_link('Next')
    expect(page).to_not have_link('Finish')
    expect(page).to have_selector('.fas.fa-thumbs-up.thumbs__gray')
    expect(page).to have_selector('.favorite-count', text: '0')

    expect {
      find('.fas.fa-thumbs-up.thumbs__gray').click
      expect(page).to have_selector('.fas.fa-thumbs-up.thumbs__yellow')
      expect(page).to have_selector('.favorite-count', text: '1')
    }.to change(learned_content.favorites, :count).by(1).and \
      change(owner.passive_favorites, :count).by(1)

    expect {
      find('.fas.fa-thumbs-up.thumbs__yellow').click
      expect(page).to have_selector('.fas.fa-thumbs-up.thumbs__gray')
      expect(page).to have_selector('.favorite-count', text: '0')
    }.to change(learned_content.favorites, :count).by(-1).and \
      change(owner.passive_favorites, :count).by(-1)

    # ダウンロードする
    expect {
      click_link 'Download'
      expect(page).to have_selector('.flash__notice', text: '"lead"の学習コンテンツをダウンロードしました。')
    }.to change(user.learned_contents, :count).by(1).and \
      change(Question, :count).by(1).and \
        change(RelatedWord, :count).by(1)

    click_link '"lead"'
    # 元のコンテンツのページに飛んではいない
    expect(current_path).to_not eq learn_path(learned_content)
    expect(page).to have_content 'star'
    expect(page).to have_content '次の復習まで: 1日 '

    expect {
      find('.fas.fa-thumbs-up.thumbs__gray').click
      expect(page).to have_selector('.fas.fa-thumbs-up.thumbs__yellow')
      expect(page).to have_selector('.favorite-count', text: '1')
    }.to change(learned_content.favorites, :count).by(1).and \
      change(owner.passive_favorites, :count).by(1)

    click_link 'Next'
    expect(current_path).to eq communities_questions_path

    # 単語ライブラリーには、元のコンテンツのみ表示されている
    find('.header-right__toggler--community').click
    find('.community-menu__list', text: '単語を探す').click
    expect(page).to have_content 'lead', count: 1
    expect(page).to have_content 'star', count: 1

    # ダウンロードした問題をもう一度解く
    visit communities_questions_path
    click_link 'Q about lead'
    expect(page).to have_selector('#question-modal')
    click_link 'Question'

    expect(page).to have_link 'Back'
    fill_in 'A:', with: 'lead'
    click_button 'Submit'

    # ダウンロード後の回答ページは自分のコンテンツのID
    expect(current_path).to_not eq question_learn_path(learned_content)
    expect(page).to_not have_selector '.fas.fa-thumbs-up'
    click_link '"lead"'

    # ダウンロードした問題を削除
    expect(page).to have_content '次の復習まで: 1日'
    expect {
      accept_alert do
        click_link 'Destroy'
      end
      expect(page).to have_selector('.flash__notice', text: '学習内容を削除しました。')
    }.to change(user.learned_contents, :count).by(-1).and \
      change(Question, :count).by(-1).and \
        change(RelatedWord, :count).by(-1)

    find('a', text: 'テストユーザー').click
    find('a', text: 'ログアウト').click

    # 元の問題作成者で確認
    actual_sign_in_as owner
    find('a', text: 'テストユーザー').click
    find('a', text: '学習履歴').click

    expect(page).to have_content 'Q about lead'
    within 'tbody tr:first-child' do # いいね数
      expect(page).to have_selector('td:nth-child(5)', text: '1')
    end
  end
end
