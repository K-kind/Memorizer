require 'rails_helper'

RSpec.describe 'Learn template', type: :system, js: true, retry: 3 do
  let(:user) { create(:user) }
  before do
    create(:word_category)
    create(:level)
    actual_sign_in_as user
  end

  it 'has a default learn template' do
    visit user_path
    aggregate_failures do
      expect(page).to have_content '意味'
      expect(page).to have_content '例文'
      expect(page).to have_content '類義語'
      expect(page).to have_content '反意語'
    end

    visit new_learn_path
    aggregate_failures do
      expect(page).to have_content '意味'
      expect(page).to have_content '例文'
      expect(page).to have_content '類義語'
      expect(page).to have_content '反意語'
    end
  end

  it 'submit-btn is disabled when with no change' do
    visit user_path

    within '#template-edit' do
      expect(page).to have_button '更新する', disabled: true

      find('#learn_template_content').set with: 'test template'
      click_button '更新する'
    end
    expect(page).to have_selector('.flash__notice', text: '学習テンプレートを更新しました。')
  end

  it 'can be set to default in each language' do
    visit user_path

    click_link 'English'
    expect(page).to have_selector('.flash__notice', text: '学習テンプレートをデフォルトに設定しました。')
    aggregate_failures do
      expect(page).to have_content 'Definition'
      expect(page).to have_content 'Examples'
      expect(page).to have_content 'Synonyms'
      expect(page).to have_content 'Antonyms'
    end

    click_link '日本語'
    expect(page).to have_selector('.flash__notice', text: '学習テンプレートをデフォルトに設定しました。')
    aggregate_failures do
      expect(page).to have_content '意味'
      expect(page).to have_content '例文'
      expect(page).to have_content '類義語'
      expect(page).to have_content '反意語'
    end
  end
end
