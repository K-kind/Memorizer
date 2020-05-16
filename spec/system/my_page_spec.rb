require 'rails_helper'

RSpec.describe 'My Page', type: :system do
  let(:user) { create(:user) }

  it 'shows user-info and default cycle' do
    sign_in_as user
    visit user_path
    within '.my-page-container__user-info' do
      expect(page).to have_content user.name
      expect(page).to have_content 'メールアドレス', count: 2
      expect(page).to have_content user.email
      expect(page).to have_content user.user_skill.skill
    end

    within '.my-page-container__user-level' do
      within 'tr:nth-child(1)' do # level
        expect(page).to have_content 1
      end
      within 'tr:nth-child(2)' do # words per week
        expect(page).to have_content 0
      end
      within 'tr:nth-child(3)' do # gross words
        expect(page).to have_content 0
      end
      within 'tr:nth-child(4)' do # gross reviews
        expect(page).to have_content 0
      end
    end

    within '.my-page-container__cycle-container' do
      expect(page).to have_field('1回目', with: 1)
      expect(page).to have_field('2回目', with: 7)
      expect(page).to have_field('3回目', with: 16)
      expect(page).to have_field('4回目', with: 35)
      expect(page).to have_field('5回目', with: 62)
    end
  end

  it 'user_name, email, user_skill can be updated', js: true do
    second_user_skill = create(:user_skill, skill: '大学受験')
    actual_sign_in_as user
    visit user_path
    # with invalid attributes
    within '.my-page-container__user-info' do
      find('a', text: '編集').click
      fill_in 'user_name', with: ' '
      fill_in 'user_email', with: 'invalid@example'
      select second_user_skill.skill, from: 'user_user_skill_id'
      click_button '保存'
    end

    aggregate_failures do
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'メールアドレスは不正な値です'
      expect(user.reload.name).to_not eq ' '
      expect(user.reload.email).to_not eq 'invalid@example'
    end

    # with valid attributes
    within '.my-page-container__user-info' do
      fill_in 'user_name', with: 'Updated name'
      fill_in 'user_email', with: 'updated_email@example.com'
      click_button '保存'
    end

    aggregate_failures do
      expect(page).to have_selector '.flash__notice', text: 'ユーザー情報を更新しました'
      expect(page).to have_content 'Updated name', count: 2
      expect(page).to have_content 'updated_email@example.com'
      expect(page).to have_content second_user_skill.skill
      expect(user.reload.name).to eq 'Updated name'
      expect(user.reload.email).to eq 'updated_email@example.com'
      expect(user.reload.user_skill.skill).to eq second_user_skill.skill
    end

    # user deletion
    expect {
      accept_alert { click_on '退会' }
      expect(current_path).to eq about_path
    }.to change(User, :count).by(-1)
  end
end
