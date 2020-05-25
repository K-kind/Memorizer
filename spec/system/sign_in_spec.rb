require 'rails_helper'

RSpec.describe 'Sign in', type: :system, retry: 3 do
  shared_examples_for 'redirected to the about page' do
    it { expect(current_path).to eq(about_path) }
  end

  describe 'visiting pages as a guest' do
    context 'when visiting root_path' do
      before { visit root_path }
      it_behaves_like 'redirected to the about page'
    end
    context 'when visiting user_path' do
      before { visit user_path }
      it_behaves_like 'redirected to the about page'
    end
    context 'when visiting communities_words_path' do
      before { visit communities_words_path }
      it_behaves_like 'redirected to the about page'
    end
    context 'when visiting communities_questions_path' do
      before { visit communities_questions_path }
      it_behaves_like 'redirected to the about page'
    end
    context 'when visiting communities_ranking_path' do
      before { visit communities_ranking_path }
      it_behaves_like 'redirected to the about page'
    end
    context 'when visiting contacts_path' do
      before { visit contacts_path }
      it_behaves_like 'redirected to the about page'
    end
    context 'when visiting consulted_words_path' do
      before { visit consulted_words_path }
      it_behaves_like 'redirected to the about page'
    end
  end

  describe 'Sign in', js: true do
    include ActiveJob::TestHelper
    let!(:user) { create(:user, password: 'valid_password') }

    before do
      visit about_path
      within 'header' do
        find('#login-link').click
      end
    end

    context 'with invalid attributes' do
      it "user can't sign in" do
        fill_in 'email-form', with: 'invalid@example.com'
        fill_in 'password', with: 'invalid_password'
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスとパスワードの組み合わせが不正です。'
      end
    end

    context 'with valid attributes' do
      it 'user can sign in and sign out' do
        fill_in 'email-form', with: user.email
        fill_in 'password', with: 'valid_password'
        click_button 'ログイン'

        wait_for_css_appear('.flash__notice') do
          expect(page).to have_content 'ログインしました。'
          expect(current_path).to eq root_path
        end

        within 'header' do
          click_on "#{user.name}(Lv.#{user.level})"
          click_on 'マイページ'
        end
        expect(current_path).to eq user_path

        # 2回連続でドロップダウンボタンを押すとすぐに消えてしまう
        find('.my-page-container__heading', match: :first).click
        within 'header' do
          click_on "#{user.name}(Lv.#{user.level})"
          click_on 'ログアウト'
        end
        expect(current_path).to eq about_path

        visit user_path
        expect(current_path).to eq about_path
      end
    end

    it 'sends a password reset mail' do
      ActionMailer::Base.deliveries.clear
      click_on 'こちら'

      perform_enqueued_jobs do
        # 無効なメールアドレス
        within '.password-reset' do
          fill_in 'email', with: 'invalid@example.com'
          click_button 'メール送信'
        end
        wait_for_css_appear('.flash__danger') do
          expect(page).to have_content 'メールアドレスが見つかりません。'
        end

        # 有効なメールアドレス
        within '.password-reset' do
          fill_in 'email', with: user.email
          click_button 'メール送信'
        end
        wait_for_css_appear('.flash__notice') do
          expect(page).to have_content 'パスワード再設定用のメールを送信しました。'
        end
      end

      expect(ActionMailer::Base.deliveries.size).to eq(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq([user.email])
      expect(user.reload.reset_digest).to be_truthy
    end
  end
end
