require 'rails_helper'

describe 'Sign up', type: :system, js: true, retry: 3 do
  include ActiveJob::TestHelper
  let!(:user_skill) { create(:user_skill) }
  let!(:admin) { create(:admin) } # 管理者メール用

  context 'with invalid attributes' do
    it 'shows error messages and does not create a user' do
      expect {
        visit about_path
        within 'header' do
          find('a', text: '新規登録').click
        end
        fill_in 'name-form', with: ''
        fill_in 'user_email', with: 'user@invalid'
        fill_in 'user_password', with: 'foo'
        fill_in 'user_password_confirmation', with: 'foo'
        click_button 'commit'
      }.to change(User, :count).by(0)

      aggregate_failures do
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(page).to have_content 'メールアドレスは不正な値です'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(page).to have_content 'スキルを入力してください'
      end
    end
  end

  context 'with valid attributes' do
    it 'creates a unactivated user and sends an activation email' do
      ActionMailer::Base.deliveries.clear
      perform_enqueued_jobs do
        expect {
          visit about_path
          within 'header' do
            find('a', text: '新規登録').click
          end
          fill_in 'name-form', with: 'テストユーザー'
          fill_in 'user_email', with: 'user@memorizer.tech'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          select user_skill.skill, from: 'user_user_skill_id'
          click_button 'commit'
          wait_for_css_appear('.flash__notice')
        }.to change(User, :count).by(1)
      end

      expect(page).to have_content '仮登録完了メールを送信しました。ご確認ください。'
      expect(ActionMailer::Base.deliveries.size).to eq(2)

      find('#login-link').click
      fill_in 'email-form', with: 'user@memorizer.tech'
      fill_in 'password', with: 'password'
      click_button 'commit'
      wait_for_css_appear('.flash__danger') do
        expect(page).to have_content \
          'アカウントが有効化されていません。仮登録確認メールをご確認ください。'
      end

      text = ActionMailer::Base
             .deliveries.first
             .body.parts.detect { |part| part.content_type == 'text/plain; charset=UTF-8' }
             .body.raw_source

      activation_token = text.scan(%r{account_activations/([^/]+)/})[0][0]

      # activation link with invalid token
      visit edit_account_activation_path('invalid token', email: 'user@memorizer.tech')
      wait_for_css_appear('.flash__danger') do
        expect(page).to have_content '有効化リンクが無効です。'
      end

      # activation link with valid token
      visit edit_account_activation_path(activation_token, email: 'user@memorizer.tech')
      wait_for_css_appear('.flash__notice') do
        expect(page).to have_content '本登録が完了しました。'
      end
      expect(page).to have_content 'ユーザー情報'
    end
  end
end
