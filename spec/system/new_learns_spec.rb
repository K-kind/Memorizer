require 'rails_helper'

RSpec.describe 'New Learn', type: :system, retry: 3 do
  include ActiveJob::TestHelper
  let(:user) { create(:user) }
  before do
    create(:word_category)
    create(:word_category, category: 'Science')
    create(:level)
    actual_sign_in_as user
    visit new_learn_path
  end

  it 'a word can be learned', js: true, vcr: { cassette_name: 'apis' } do
    # 無効な検索
    fill_in 'word', with: ' '
    click_button 'consult-submit'
    expect(page).to have_selector('p', text: '" "は英語ではありません')

    fill_in 'word', with: 'あいうえお'
    click_button 'consult-submit'
    expect(page).to have_selector('p', text: '"あいうえお"は英語ではありません')

    fill_in 'word', with: 'mistaake'
    click_button 'consult-submit'
    expect(page).to have_selector('p', text: '"mistaake"の検索結果:0件')
    expect(page).to have_selector('p', text: '"mistaake"と似た単語')
    expect(page).to have_content 'mistake'

    # 1つ目の単語を調べて、消す
    fill_in 'word', with: 'temporary'
    click_button 'consult-submit'
    expect(page).to have_selector('.dictionary-heading__word', text: 'temporary')
    find('.remove-word-btn').click
    expect(page).to_not have_selector('.dictionary-heading__word', text: 'temporary')

    # 2つ目の単語lead
    expect {
      fill_in 'word', with: 'lead'
      click_button 'consult-submit'
      expect(page).to have_selector('.dictionary-heading__word', text: 'lead')
    }.to change(WordDefinition, :count).by(1)

    find('.thesaurus-toggler').click
    find('.thesaurus-word-tab', text: 'noun').click
    expect(page).to have_selector('.thesaurus-heading__word', text: 'lead')
    expect(page).to have_selector('.word-class', text: 'noun')

    expect(page).to have_selector('#pixabay-link', text: '"lead"')

    expect(page).to have_select('Main word:', selected: 'lead')

    # 3つ目の単語starを検索
    expect {
      fill_in 'word', with: 'star'
      click_button 'consult-submit'
      expect(page).to have_selector('.dictionary-heading__word', text: 'star')
    }.to change(WordDefinition, :count).by(1)

    find('.thesaurus-toggler').click
    find('.thesaurus-word-tab', text: 'adjective').click
    expect(page).to have_selector('.thesaurus-heading__word', text: 'star')
    expect(page).to have_selector('.word-class', text: 'adjective')

    expect(page).to have_selector('#pixabay-link', text: '"star"')

    expect(page).to have_select('Main word:', selected: 'lead', options: %w[lead star])

    # leadに戻ると、thesaurusのままになっている
    find('.consulted-word-lead').click
    expect(page).to have_selector('.thesaurus-heading__word', text: 'lead')
    expect(page).to have_selector('.word-class', text: 'noun')

    expect(page).to have_selector('#pixabay-link', text: '"lead"')

    # starがフォームに入ったまま、再検索
    click_button 'consult-submit'
    expect(page).to have_selector('.thesaurus-heading__word', text: 'star')
    expect(page).to have_selector('.word-class', text: 'adjective')

    expect(user.consulted_words.count).to eq 3

    # それぞれ値を設定
    find('#learned_content_content').set('I learned the word star.')
    fill_in 'Question 1', with: 'Question about star'
    fill_in 'Answer 1', with: 'Answer for Q1'
    find('.add-next-box', text: 'more').click
    fill_in 'Question 2', with: 'Another Question'
    find_field('Answer 2').fill_in with: 'Answer for Q2'
    select 'star', from: 'Main word:'
    select 'Science', from: 'Category:'
    choose 'Private'

    # Quick question
    find('a', text: 'Quick').click
    expect(page).to have_field 'Question 1',
                               with: /burning gas and that look like points of light in the night sky/
    expect(page).to have_field 'Answer 1', with: 'star'

    within('.pixabay-btn') { click_on '"star"' }
    within '#images-result' do
      # 画像を保存（星をつける）
      expect(page).to have_selector('h4', text: 'Images for "star"')
      expect(page).to have_selector('img[alt="image of star"]')
      find('.image-save-btn', match: :first).click
      expect(page).to have_selector('.image-unsave-star')
    end
    within '.learn-grid-container__saved-images' do
      # 学習画面の中から画像を削除
      expect(page).to have_selector('img[alt="image of star"]')
      find('.image-unsave-times').click
      expect(page).to_not have_selector('img[alt="image of star"]')
    end
    within '#images-result' do
      # imagesの中でも星は消えていることを確認し、もう一度保存
      expect(page).to_not have_selector('.image-unsave-star')
      find('.image-save-btn', match: :first).click
    end

    # save the image for 'lead'
    find('.consulted-word-lead').click
    find('#pixabay-link', text: '"lead"').click
    within '#images-result' do
      expect(page).to have_selector('h4', text: 'Images for "lead"')
      find('.image-save-btn', match: :first).click
    end
    within '.learn-grid-container__saved-images' do
      expect(page).to have_selector('img[alt="image of star"]')
      expect(page).to have_selector('img[alt="image of star"]')
    end

    # Save
    perform_enqueued_jobs do
      expect {
        click_button 'Save'
        expect(page).to have_selector('.flash__notice', text: '学習が記録されました。')
      }.to change(user.learned_contents, :count).by(1)
    end

    expect(current_path).to eq learn_path(user.learned_contents.last)

    within '.learn-grid-container__study-field' do
      expect(page).to have_selector('.learn-grid-container__main-word-show', text: 'star')
      expect(page).to have_content 'I learned the word star.'
      expect(page).to have_content 'burning gas and that look like points of light in the night sky'
      expect(page).to have_content 'star'
      expect(page).to have_content 'Another Question'
      expect(page).to have_content 'Answer for Q2'
      expect(page).to have_content 'Science'
      expect(page).to have_content 'Private'
      expect(page).to have_selector('img[alt="image of star"]')
      expect(page).to have_selector('img[alt="image of lead"]')
    end
    expect(page).to have_selector('.active-word', text: 'star')
    expect(page).to have_content 'Until next review: 1 day'

    # Privateなcontentは公開されない
    visit communities_questions_path
    expect(page).not_to have_content '[Definition]'
    visit communities_words_path
    expect(page).not_to have_content 'star'

    # 自分の問題一覧には表示される
    visit learns_path
    click_on '[Definition]'
    find('.question-modal__review-link').click

    click_on 'Edit'
    expect(page).to have_selector('.dictionary-heading__word', text: 'star')

    # 単語を追加
    fill_in 'word', with: 'yellow'
    click_button 'consult-submit'
    expect(page).to have_selector('.dictionary-heading__word', text: 'yellow')

    # 無効な編集
    fill_in 'Answer 2', with: ' '
    click_button 'Save'
    expect(page).to have_selector('.error-message__list', text: '答えを入力してください')

    # 有効な編集
    select 'yellow', from: 'Main word:'
    find('#learned_content_content').set('I learned the word yellow.')
    fill_in 'Question 2', with: 'Question about yellow'
    fill_in 'Answer 2', with: 'The answer is yellow'
    select 'General', from: 'Word category'
    choose 'public'

    # starの画像を削除、yellowの画像を追加
    find('.image-unsave-times__s3', match: :first).click
    expect(page).to_not have_selector('img[alt="image of star"]')

    find('#pixabay-link', text: '"yellow"').click
    find('.image-save-btn', match: :first).click
    within '.learn-grid-container__saved-images' do
      expect(page).to have_selector('img[alt="image of yellow"]')
    end

    perform_enqueued_jobs do
      click_button 'Save'
    end

    expect(page).to have_selector('.flash__notice', text: '学習内容が更新されました。')
    expect(current_path).to eq learn_path(user.learned_contents.last)

    within '.learn-grid-container__study-field' do
      expect(page).to have_selector('.learn-grid-container__main-word-show', text: 'yellow')
      expect(page).to have_content 'I learned the word yellow.'
      expect(page).to have_content 'Question about yellow'
      expect(page).to have_content 'The answer is yellow'
      expect(page).to have_content 'General'
      expect(page).to have_content 'Public'
      expect(page).to have_selector('img[alt="image of lead"]')
      expect(page).to have_selector('img[alt="image of yellow"]')
    end
    expect(page).to have_selector('.active-word', text: 'yellow')
    expect(user.learned_contents.last.related_images.count).to eq 2

    # Publicなコンテンツは公開される
    visit communities_questions_path
    expect(page).to have_content '[Definition]'
    visit communities_words_path
    expect(page).to have_content 'yellow'
    expect(page).to have_content 'lead'
    expect(page).to have_content 'star'

    # 単語検索履歴
    visit consulted_words_path
    expect(page).to have_content 'temporary'
    expect(page).to have_content 'lead'
    expect(page).to have_content 'star'
    expect(page).to have_content 'yellow'
    expect(page).to_not have_content 'mistaake'

    # ダッシュボードに学習が表示される
    visit root_path
    expect(page).to have_selector('.home-top__count', text: '1')
    click_on '[Definition]'
    find('.question-modal__review-link').click

    # destroy the learned content
    accept_alert do
      click_on 'Destroy'
    end
    expect(page).to have_selector('.home-top__count', text: '0')
    expect(page).to_not have_content '[Definition]'

    visit communities_questions_path
    expect(page).not_to have_content '[Definition]'
    visit communities_words_path
    expect(page).not_to have_content 'yellow'
  end
end
