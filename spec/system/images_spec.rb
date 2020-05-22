require 'rails_helper'

RSpec.describe 'Images', type: :system, js: true, vcr: { cassette_name: 'apis' }, retry: 3 do
  include ActiveJob::TestHelper
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  before do
    create(:word_category)
    create(:level)
    actual_sign_in_as user
  end

  it 'related images appear in the question page and can be downloaded', :perform_enqueued_jobs do
    # make a content with a image
    visit new_learn_path
    fill_in 'word', with: 'lead'
    click_button 'consult-submit'
    find('#pixabay-link', text: 'lead').click
    find('.image-save-btn', match: :first).click
    find('#learned_content_content').set('I learned the word star.')
    fill_in 'Question 1', with: 'Q about lead'
    fill_in 'Answer 1', with: 'The answer is lead'
    click_button 'Save'
    expect(page).to have_selector('.flash__notice', text: '学習が記録されました')

    # login as other user
    click_link 'テストユーザー'
    find('a', text: 'ログアウト').click
    actual_sign_in_as other_user

    # go to the question page with image
    visit communities_questions_path
    find('a', text: 'Q about lead').click
    find('a', text: 'Question').click
    expect(page).to have_selector('img[alt="image of lead"]')
    fill_in 'A:', with: 'lead'
    click_button 'Submit'

    # download the content
    expect(page).to have_selector('img[alt="image of lead"]')
    expect {
      click_link 'Download'
      expect(page).to have_selector('.flash__notice', text: '学習コンテンツをダウンロードしました。')
    }.to change(RelatedImage, :count).by(1)
    find('a', text: 'lead').click

    # destroy the content
    expect(page).to have_selector('img[alt="image of lead"]')
    expect {
      accept_alert do
        click_link 'Destroy'
      end
      expect(page).to have_selector('.flash__notice', text: '学習内容を削除しました。')
    }.to change(RelatedImage, :count).by(-1)
  end
end
