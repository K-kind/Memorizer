require 'rails_helper'

RSpec.describe 'Validation for learning', type: :system, js: true, vcr: { cassette_name: 'apis' }, retry: 3 do
  include ActiveJob::TestHelper
  let(:user) { create(:user) }
  before do
    create(:word_category)
    create(:level)
    actual_sign_in_as user
    visit new_learn_path
  end

  context 'in the new learn page' do
    it 'validation for numbers of images' do
      fill_in 'word', with: 'lead'
      click_button 'consult-submit'
      find('#pixabay-link', text: 'lead').click
      page.all('.image-save-btn')[0].click
      page.all('.image-save-btn')[1].click
      page.all('.image-save-btn')[2].click
      page.all('.image-save-btn')[3].click
      click_button 'Save'
      sleep(2)
      expect(page).to have_selector('.error-message__list', text: '画像は3枚まで保存できます。')

      find('.image-unsave-times', match: :first).click
      click_button 'Save'
      sleep(2)
      expect(page).to_not have_selector('.error-message__list', text: '画像は3枚まで保存できます。')
    end

    it 'validation for questions' do
      sleep(0.3)
      click_button 'Save'
      sleep(2.5)
      expect(page).to have_selector('.error-message__list', count: 2)
      expect(page).to have_selector('.error-message__list', text: '1つ以上の単語を検索してください。')
      expect(page).to have_selector('.error-message__list', text: '1つ以上の問題を入力してください。')

      # バツボタンでエラーメッセージを消す
      find('.learn-grid-container__error-hide').click
      expect(page).to_not have_selector('.error-message__list')

      fill_in 'word', with: 'lead'
      click_button 'consult-submit'
      wait_for_css_appear '.dictionary-heading__word'
      click_button 'Save'

      expect(page).to have_selector('.error-message__list', count: 1)
      expect(page).to have_selector('.error-message__list', text: '1つ以上の問題を入力してください。')
      expect(page).to_not have_selector('.error-message__list', text: '1つ以上の単語を検索してください。')

      # only with Q
      find('#learned_content_content').set('I learned the word star.')
      fill_in 'Question 1', with: 'Question about star'
      click_button 'Save'
      sleep(1)
      expect(page).to have_selector('.error-message__list', text: '答えを入力してください')
      expect(page).to_not have_selector('.error-message__list', text: '1つ以上の問題を入力してください。')
      expect(page).to have_selector('.error-message__list', count: 1)

      # only with A
      fill_in 'Question 1', with: ' '
      fill_in 'Answer 1', with: 'Answer for Q1'
      click_button 'Save'
      sleep(1)
      expect(page).to have_selector('.error-message__list', text: '問題を入力してください')
      expect(page).to_not have_selector('.error-message__list', text: '1つ以上の問題を入力してください。')
      expect(page).to have_selector('.error-message__list', count: 1)

      # with Q & A and only Q2
      fill_in 'Question 1', with: 'Question about star'
      find('.add-next-box', text: 'more').click
      find_field('Question 2').fill_in with: 'Another Question'
      click_button 'Save'
      sleep(1.5)
      expect(page).to have_selector('.error-message__list', text: '答えを入力してください')
      expect(page).to have_selector('.error-message__list', count: 1)
    end
  end

  context 'in the edit page' do
    it 'validation for numbers of images', perform_enqueued_jobs: true do
      # save a content
      fill_in 'word', with: 'lead'
      click_button 'consult-submit'
      find('#pixabay-link', text: 'lead').click
      page.all('.image-save-btn')[0].click

      find('a', text: 'Quick').click

      click_button 'Save'
      expect(page).to have_selector('.flash__notice', text: '学習が記録されました')

      # edit page with 1 image
      click_link 'Edit'
      find('#pixabay-link').click
      page.all('.image-save-btn')[0].click
      page.all('.image-save-btn')[1].click
      page.all('.image-save-btn')[2].click

      # 4 images
      click_button 'Save'
      sleep(1)
      expect(page).to have_selector('.error-message__list', text: '画像は3枚まで保存できます。')
      expect(page).to have_selector('.error-message__list', count: 1)

      # 3 images
      find('.image-unsave-times', match: :first).click
      click_button 'Save'
      expect(page).to have_selector('.flash__notice', text: '学習内容が更新されました')
    end

    it 'validation for questions' do
      # save a content with 3 questions
      fill_in 'word', with: 'lead'
      click_button 'consult-submit'

      find_field('Question 1').fill_in with: 'Question 1'
      find_field('Answer 1').fill_in with: 'Answer 1'

      find('.add-next-box', text: 'more').click
      find_field('Question 2').fill_in with: 'Question 2'
      find_field('Answer 2').fill_in with: 'Answer 2'

      find('.add-next-box', text: 'more').click
      find_field('Question 3').fill_in with: 'Question 3'
      find_field('Answer 3').fill_in with: 'Answer 3'

      click_button 'Save'
      expect(page).to have_selector('.flash__notice', text: '学習が記録されました')

      # edit page
      click_link 'Edit'
      expect(page).to have_selector('.error-message__list', count: 0)

      # with A1 QA2 QA3
      fill_in 'Question 1', with: ' '
      click_button 'Save'
      sleep(1)
      expect(page).to have_selector('.error-message__list', text: '問題を入力してください')
      expect(page).to have_selector('.error-message__list', count: 1)

      # with Q2 QA3
      fill_in 'Answer 1', with: ' '
      fill_in 'Answer 2', with: ' '
      click_button 'Save'
      sleep(1)
      expect(page).to have_selector('.error-message__list', text: '答えを入力してください')
      expect(page).to have_selector('.error-message__list', count: 1)

      # with no questions
      fill_in 'Question 2', with: ' '
      fill_in 'Question 3', with: ' '
      fill_in 'Answer 3', with: ' '
      click_button 'Save'
      sleep(1)
      expect(page).to have_selector('.error-message__list', text: '1つ以上の問題を入力してください。')
      expect(page).to have_selector('.error-message__list', count: 1)

      # with QA1
      fill_in 'Question 1', with: 'Question 1'
      fill_in 'Answer 1', with: 'Answer 1'
      click_button 'Save'
      expect(page).to have_selector('.flash__notice', text: '学習内容が更新されました')
    end
  end
end
