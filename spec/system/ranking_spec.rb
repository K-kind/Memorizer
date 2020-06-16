require 'rails_helper'

RSpec.describe 'Ranking', type: :system, js: true, retry: 3 do
  let(:user_skill) { create(:user_skill) }
  let(:tester) { create(:user, name: 'テスター', user_skill: user_skill) }
  let(:favoriter) { create(:user, name: 'No content', user_skill: user_skill) }
  let(:word_category) { create(:word_category) }
  let(:word_definition) { create(:word_definition) }
  let(:calendar) { create(:calendar) }

  before do
    15.times do |n|
      user = create(:user, name: "ユーザー#{n + 1}", user_skill: user_skill)
      (n + 1).times do
        learned_content = create(:learned_content,
                                 user: user,
                                 word_definition: word_definition,
                                 word_category: word_category,
                                 calendar: calendar)
        learned_content.favorites.create!(user: favoriter)
      end
    end

    # tester has learned_contents and favorites 1 for this week and 16 for past day
    17.times do |n|
      date = n == 0 ? Time.zone.today : Time.zone.today - 7
      learned_content = create(:learned_content,
                               user: tester,
                               word_definition: word_definition,
                               word_category: word_category,
                               calendar: calendar,
                               created_at: date)
      learned_content.favorites.create!(user: favoriter, created_at: date)
    end

    actual_sign_in_as tester
  end

  it 'is correctly shown' do
    visit communities_ranking_path

    # No. of learns this week
    within '#ranking-table' do
      expect(page).to have_selector('tbody tr:first-child td:nth-child(2)', text: 'ユーザー15')
      expect(page).to have_selector('tbody tr:first-child td:nth-child(4)', text: '15')
      paginate_and_wait 2
      # my ranking row
      expect(page).to have_selector('.community-ranking-container__my-tr td:nth-child(4)', text: '1')
      expect(page).to_not have_content 'No content'
    end

    # gross No. of learns
    find('#learn_period').select '総合' # paginationは元に戻る
    wait_for_ajax
    within '#ranking-table' do
      expect(page).to have_selector('tbody tr:first-child td:nth-child(2)', text: 'テスター')
      expect(page).to have_selector('.community-ranking-container__my-tr td:nth-child(4)', text: '17')
      paginate_and_wait 2
      expect(page).to_not have_content 'No content'
    end

    # No. of favorites this week
    within '#favo-ranking-table' do
      expect(page).to have_selector('tbody tr:first-child td:nth-child(2)', text: 'ユーザー15')
      expect(page).to have_selector('tbody tr:first-child td:nth-child(4)', text: '15')
      paginate_and_wait 2
      # my ranking row
      expect(page).to have_selector('.community-ranking-container__my-tr td:nth-child(4)', text: '1')
      expect(page).to_not have_content 'No content'
    end

    # gross No. of favorites
    find('#favorite_period').select '総合'
    wait_for_ajax
    within '#favo-ranking-table' do
      expect(page).to have_selector('tbody tr:first-child td:nth-child(2)', text: 'テスター')
      expect(page).to have_selector('.community-ranking-container__my-tr td:nth-child(4)', text: '17')
      paginate_and_wait 2
      expect(page).to_not have_content 'No content'
    end
  end
end
