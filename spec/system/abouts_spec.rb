require 'rails_helper'

RSpec.describe 'About_page', type: :system do
  include ActiveJob::TestHelper
  let(:user) { create(:user) }

  describe 'test-user-login button and sign-up button' do
    context 'when not logged in' do
      specify 'shown' do
        visit about_path
        expect(page).to have_content 'テストユーザーで体験！'
        expect(page).to have_content '新規登録！'
        expect(page).to_not have_content '単語を学習する'
      end
    end

    context 'when logged in' do
      specify 'hidden' do
        sign_in_as user
        visit about_path
        expect(page).to_not have_content 'テストユーザーで体験！'
        expect(page).to_not have_content '新規登録！'
        expect(page).to have_content '単語を学習する'
      end
    end
  end

  it 'test users are availavle', perform_enqueued_jobs: true, js: true do
    test_user = create(:user, email: 'test_user1@memorizer.tech',
                              name: 'テストユーザー1')
    allow(User).to receive(:find_by).and_return(test_user)
    visit about_path
    click_link 'テストユーザーで体験！', match: :first
    aggregate_failures do
      expect(page).to have_content "#{test_user.name}でログインしました。データは1時間ごとにリセットされます。"
      expect(page).to have_content '本日の学習'
      expect(page).to have_content "#{test_user.name}(Lv.1)"
    end
  end
end
