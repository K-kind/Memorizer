# require 'rails_helper'

# describe 'ユーザー新規登録、ログイン機能', type: :system, js: true do
#   let!(:user_skill) { create(:user_skill) }
#   let!(:admin) { create(:admin) }

#   describe '新規登録' do
#     context '無効な情報' do
#       before do
#         @user_count = User.count
#         visit about_path
#         within 'header' do
#           click_on '新規登録'
#         end
#         fill_in 'name-form', with: ''
#         fill_in 'user_email', with: 'user@invalid'
#         fill_in 'user_password', with: 'foo'
#         fill_in 'user_password_confirmation', with: 'foo'
#         click_button 'commit'
#       end

#       it 'エラーメッセージが表示される' do
#         expect(page).to have_content 'ユーザー名を入力してください'
#         expect(page).to have_content 'メールアドレスは不正な値です'
#         expect(page).to have_content 'パスワードは6文字以上で入力してください'
#         expect(page).to have_content 'スキルを入力してください'
#       end

#       it '無効なユーザーは登録されていない' do
#         expect(User.count).to eq(@user_count)
#       end
#     end

#     context '有効な情報' do
#       before do
#         ActionMailer::Base.deliveries.clear
#         @user_count = User.count
#         visit about_path
#         within 'header' do
#           click_on '新規登録'
#         end
#         fill_in 'name-form', with: 'テストユーザー'
#         fill_in 'user_email', with: 'user@memorizer.tech'
#         fill_in 'user_password', with: 'password'
#         fill_in 'user_password_confirmation', with: 'password'
#         select user_skill.skill, from: 'user_user_skill_id'
#         click_button 'commit'
#         @user = User.find_by(email: 'user@memorizer.tech')
#       end

#       it 'メール発送通知が表示される' do
#         expect(page).to have_content '仮登録完了メールを送信しました。ご確認ください。'
#       end

#       it 'メールが発送される' do
#         sleep 3
#         expect(ActionMailer::Base.deliveries.size).to be >= 1
#       end

#       it 'ユーザーが保存される' do
#         sleep 3
#         expect(User.count).to eq(@user_count + 1)
#       end

#       it 'ユーザーはまだ有効化されていない' do
#         expect(@user.activated?).to be_falsey
#       end

#       it '有効化していないユーザーがログインを試みるとメッセージが表示される' do
#         within 'header' do
#           click_on 'ログイン', wait: 7
#         end
#         fill_in 'email-form', with: 'user@memorizer.tech'
#         fill_in 'password', with: 'password'
#         click_button 'commit'
#         expect(page).to have_content 'アカウントが有効化されていません。仮登録確認メールをご確認ください。'
#       end

#       it '無効なトークンを含む有効化URLでは有効化はできない' do
#         visit edit_account_activation_path('invalid token', email: @user.email)
#         expect(page).to have_content '有効化リンクが無効です。'
#       end
#     end
#   end
# end
