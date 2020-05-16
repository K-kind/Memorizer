require 'rails_helper'

RSpec.describe 'Index of contents', type: :system, js: true, vcr: { cassette_name: 'apis' }, retry: 3 do
  let(:user_800) { create(:user) }
  let(:user_900) { create(:user, :skill_900) }
  let(:calendar_800) { user_800.calendars.create!(calendar_date: Time.zone.today) }
  let(:calendar_900) { user_900.calendars.create!(calendar_date: Time.zone.today) }
  let(:word_definition_test) { create(:word_definition) }
  let(:word_definition_lead) { create(:word_definition, :lead) }
  let(:word_definition_star) { create(:word_definition, :star) }
  let(:word_category_science) { WordCategory.create!(category: 'Science') }
  let(:word_category_technology) { WordCategory.create!(category: 'Technology') }

  before do
    create(:level)
    # Word: "test", UserSkill: 800, Category: Science
    15.times do |n|
      content = create(:learned_content,
                       user: user_800,
                       calendar: calendar_800,
                       word_category: word_category_science,
                       word_definition: word_definition_test,
                       review_date: Time.zone.today + 15 - n,
                       created_at: Time.zone.local(2021, 1, n + 1))
      create(:question,
             learned_content: content,
             question: "Learn#{n + 1} Q")
    end

    # Word: "lead", UserSkill: 900, Category: General
    learned_content900 =
      create(:learned_content,
             user: user_900,
             calendar: calendar_900,
             word_definition: word_definition_lead,
             created_at: Time.zone.local(2020, 12, 1))
    learned_content900.questions.create!(
      question: 'General 900 Q',
      answer: 'Answer lead'
    )

    # Word: 'star', Userskill: 800, Category: Technology
    learned_content800 = \
      create(:learned_content,
             user: user_800,
             calendar: calendar_800,
             word_category: word_category_technology,
             word_definition: word_definition_star,
             created_at: Time.zone.local(2020, 12, 2))
    learned_content800.questions.create!(
      question: 'Technology Q',
      answer: 'Answer star'
    )
    # related_word: 'test'
    learned_content800.related_words.create!(word_definition: word_definition_test)
    learned_content800.favorites.create!(user: user_900)

    actual_sign_in_as user_800
  end

  it 'contents can be sorted and reserved' do
    # 問題一覧
    click_link 'テストユーザー'
    find('a', text: '問題一覧').click
    # 作成日順
    expect(page).to have_content '2021/01/15'
    click_link '作成日'
    expect(page).to have_selector('.sort_link.asc', text: '作成日')
    expect(page).to have_selector('td', text: '2021/01/01')
    expect(page).to_not have_content '2021/01/15'
    paginate_and_wait 2
    expect(page).to have_selector('td', text: '2021/01/15')

    # いいね順
    paginate_and_wait 1
    click_link 'いいね数'
    expect(page).to have_selector('.sort_link.desc', text: 'いいね数')
    expect(page).to have_selector('tr:first-child td:nth-child(5)', text: '1')
    click_link 'いいね数'
    expect(page).to have_selector('.sort_link.asc', text: 'いいね数')
    expect(page).to_not have_selector('td:nth-child(5)', text: '1')
    paginate_and_wait 2
    expect(page).to have_selector('td:nth-child(5)', text: '1')

    # 次の復習日順
    paginate_and_wait 1
    click_link '復習まで' # 昇順
    sleep(0.4)
    expect(page).to have_selector('.sort_link.asc', text: '復習まで')
    expect(page).to have_selector('tr:first-child td:nth-child(3)', text: '1日')
    expect(page).to_not have_selector('td:nth-child(3)', text: '15日')
    paginate_and_wait 2
    sleep(0.4)
    expect(page).to have_selector('td:nth-child(3)', text: '15日')
    paginate_and_wait 1
    click_link '復習まで' # 降順
    expect(page).to have_selector('.sort_link.desc', text: '復習まで')
    expect(page).to have_selector('tr:first-child td:nth-child(3)', text: '15日')
    expect(page).to_not have_selector('td:nth-child(3)', text: /^1日/)

    # カテゴリー検索
    select 'General', from: 'カテゴリーで探す:'
    wait_for_css_disappear('tbody tr')
    expect(page).to_not have_selector('tbody tr')
    select 'Technology', from: 'カテゴリーで探す:'
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to have_content 'Technology Q'
    select 'Science', from: 'カテゴリーで探す:'
    wait_for_ajax
    expect(page).to_not have_content 'Technology Q'
    paginate_and_wait(2)
    expect(page).to_not have_content 'Technology Q'

    # 単語で検索 カテゴリーscience
    fill_in '単語で探す:', with: 'star'
    click_button 'button'
    wait_for_css_disappear('tbody tr')
    expect(page).to_not have_selector('tbody tr')
    fill_in '単語で探す:', with: 'test'
    click_button 'button'
    expect(page).to have_selector('tbody tr')

    # 単語で検索 カテゴリーtechnology 関連語testが検索される
    select 'Technology', from: 'カテゴリーで探す:'
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to have_content 'Technology Q'
    fill_in '単語で探す:', with: 'star'
    click_button 'button'
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to have_content 'Technology Q'

    # 単語で検索 カテゴリーGeneral
    select 'General', from: 'カテゴリーで探す:'
    wait_for_css_disappear('tbody tr')
    expect(page).to_not have_selector('tbody tr')
    fill_in '単語で探す:', with: ''
    click_button 'button'
    wait_for_css_disappear('tbody tr')
    expect(page).to_not have_selector('tbody tr')
    select 'All', from: 'カテゴリーで探す:'
    expect(page).to have_selector('tbody tr')

    # みんなの問題
    find('.header-right__toggler--community').click
    find('.community-menu__list', text: 'みんなの問題').click

    # 作成日順
    expect(page).to have_selector('tr:first-child td:nth-child(5)', text: '2021/01/15')
    click_link '作成日'
    expect(page).to have_selector('.sort_link.asc', text: '作成日')
    expect(page).to_not have_content '2021/01/15'
    paginate_and_wait(2)
    expect(page).to have_content '2021/01/15'

    # いいね順
    paginate_and_wait(1)
    click_link 'いいね数'
    expect(page).to have_selector('.sort_link.desc', text: 'いいね数')
    expect(page).to have_selector('tr:first-child td:nth-child(4)', text: '1')
    click_link 'いいね数'
    expect(page).to have_selector('.sort_link.asc', text: 'いいね数')
    expect(page).to_not have_selector('td:nth-child(4)', text: '1')
    paginate_and_wait(2)
    expect(page).to have_selector('td:nth-child(4)', text: '1')

    # ユーザースキル 900 1件
    select 'TOEIC900点相当', from: 'スキルで探す:'
    sleep(0.4)
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to have_content 'General 900 Q'

    # ユーザースキル 800
    select 'TOEIC800点相当', from: 'スキルで探す:'
    sleep(0.4)
    expect(page).to_not have_content 'General 900 Q'
    paginate_and_wait(2)
    expect(page).to_not have_content 'General 900 Q'

    # カテゴリー General with 800 なし
    select 'General', from: 'カテゴリーで探す:'
    sleep(0.4)
    expect(page).to_not have_selector('tbody tr')

    # カテゴリー General with 900 1件
    select 'TOEIC900点相当', from: 'スキルで探す:'
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to have_content 'General 900 Q'

    # カテゴリー Technology with 900 なし
    select 'Technology', from: 'カテゴリーで探す:'
    sleep(0.4)
    expect(page).to_not have_selector('tbody tr')

    # カテゴリー Technology with 800 1件
    select 'TOEIC800点相当', from: 'スキルで探す:'
    wait_for_ajax
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to have_content 'Technology Q'

    # カテゴリー Science with 800 15件 ソートもできる
    select 'Science', from: 'カテゴリーで探す:'
    wait_for_ajax
    expect(page).to have_selector('tr:first-child td', text: '2021/01/15')
    click_on '作成日'
    expect(page).to have_selector('.sort_link.asc', text: '作成日')
    expect(page).to_not have_content '2021/01/15'
    paginate_and_wait(2)
    expect(page).to have_content '2021/01/15'

    # user_900でログイン（他人の問題をダウンロードした後の挙動を知るため）
    click_link 'テストユーザー'
    find('a', text: 'ログアウト').click
    actual_sign_in_as user_900
    find('.header-right__toggler--community').click
    find('.community-menu__list', text: 'みんなの問題').click
    sleep(0.3)
    expect(page).to have_select('スキルで探す:', selected: 'All')
    expect(page).to have_select('カテゴリーで探す:', selected: 'All')

    # セッションを設定
    expect(page).to_not have_content 'Technology Q'
    select 'TOEIC800点相当', from: 'スキルで探す:'
    sleep(0.5)
    click_link 'いいね数' # 降順
    sleep(0.5)
    expect(page).to have_selector('.sort_link.desc', text: 'いいね数')
    click_link 'いいね数' # 昇順
    expect(page).to have_selector('.sort_link.asc', text: 'いいね数')
    paginate_and_wait(2)
    expect(page).to have_content 'Technology Q'

    # 問題ページから戻る
    click_link 'Technology Q'
    sleep(0.3)
    click_link 'Question'
    click_link 'Back'
    sleep(0.3)
    expect(page).to have_select('スキルで探す:', selected: 'TOEIC800点相当')
    expect(page).to have_content 'Technology Q'

    # 回答ページから戻る
    click_link 'Technology Q'
    sleep(0.3)
    click_link 'Question'
    fill_in 'A:', with: 'answer'
    click_button 'Submit'
    find('a', text: 'Next').click
    sleep(0.3)
    expect(page).to have_select('スキルで探す:', selected: 'TOEIC800点相当')
    expect(page).to have_content 'Technology Q'

    # ダウンロードしたshowページから戻る
    click_link 'Technology Q'
    sleep(0.3)
    click_link 'Question'
    fill_in 'A:', with: 'answer'
    click_button 'Submit'
    click_link 'Download'
    find('a', text: '"star"').click
    sleep(0.3)
    click_link 'Next'
    sleep(0.3)
    expect(page).to have_select('スキルで探す:', selected: 'TOEIC800点相当')
    expect(page).to have_content 'Technology Q'

    # ナビバーから戻るとセッションは残っていない
    find('.header-right__toggler--community').click
    find('.community-menu__list', text: 'みんなの問題').click
    sleep(0.3)
    expect(page).to have_select('スキルで探す:', selected: 'All')
    expect(page).to have_select('カテゴリーで探す:', selected: 'All')

    # 単語を探す デフォルトは作成日降順
    find('.header-right__toggler--community').click
    find('.community-menu__list', text: '単語を探す').click
    expect(page).to have_content 'lead'
    expect(page).to have_content 'star'

    # スキル900 main: lead 1件
    select 'TOEIC900点相当', from: 'スキルで探す:'
    sleep(0.4)
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to have_selector('td', text: 'lead')

    # スキル800 main: star, test 15件
    select 'TOEIC800点相当', from: 'スキルで探す:'
    sleep(0.4)
    expect(page).to have_selector('td:nth-child(1)', text: 'star')
    expect(page).to have_selector('td:nth-child(2)', text: 'test')
    expect(page).to_not have_selector('td', text: 'lead')
    paginate_and_wait 2
    expect(page).to_not have_selector('td', text: 'lead')

    # スキル800, Technology main: star, test 1件
    select 'Technology', from: 'カテゴリーで探す:'
    sleep(0.4)
    expect(page).to have_selector('td:nth-child(1)', text: 'star')
    expect(page).to have_selector('td:nth-child(2)', text: 'test')
    expect(page).to have_selector('tbody tr', count: 1)
    expect(page).to_not have_selector('td', text: 'lead')
    expect(page).to_not have_selector('td:nth-child(1)', text: 'test')
  end
end
