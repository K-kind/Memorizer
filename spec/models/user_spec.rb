require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー作成や削除' do
    let(:user) do
      build(:user, name: 'ユーザーA',
                   email: 'a@example.com',
                   password: 'password')
    end

    it 'ユーザーAが有効であること' do
      expect(user).to be_valid
    end

    it '名前が空白ならば無効になること' do
      user.name = ' '
      expect(user).to be_invalid
    end

    it 'メールアドレスが空白ならば無効になること' do
      user.email = ' '
      expect(user).to be_invalid
    end

    it '20文字より長い名前は無効になること' do
      user.name = 'a' * 21
      expect(user).to be_invalid
    end

    it '255文字より長いメールアドレスは無効になること' do
      user.email = 'a' * 244 + '@example.com'
      expect(user).to be_invalid
    end

    it '有効なメールアドレスがバリデーションを通ること' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]

      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    it '無効なメールアドレスがバリデーションに通らないこと' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com foo@bar..com]

      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to be_invalid
      end
    end

    it '大文字・小文字を区別せず同一のメールアドレスは無効になること' do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user).to be_invalid
    end

    it 'メールアドレスは小文字で保存されること' do
      mixed_case_email = 'Foo@ExAMPle.CoM'
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq(mixed_case_email.downcase)
    end

    it '空のパスワードは無効になること' do
      user.password = ' ' * 6
      expect(user).to be_invalid
    end

    it '5文字以下のパスワードは無効になること' do
      user.password = 'a' * 5
      expect(user).to be_invalid
    end

    it 'authenticated?メソッドはdigestがnilの場合にfalseを返すこと' do
      expect(user.authenticated?(:remember, '')).to be_falsey
    end

    it '関連付けられたlearned_content, review_historyが削除されること' do
      user.save
      learned_content = create(:learned_content, user: user)
      create(:review_history, learned_content: learned_content)
      expect { user.destroy }.to \
        change { LearnedContent.count }.by(-1).and change { ReviewHistory.count }.by(-1)
    end

    it '関連付けられたconsulted_wordが削除されること' do
      user.save
      create(:consulted_word, user: user)
      expect { user.destroy }.to change { ConsultedWord.count }.by(-1)
    end

    it '関連付けられたcontactが削除されること' do
      user.save
      create(:contact, user: user)
      expect { user.destroy }.to change { Contact.count }.by(-1)
    end

    it '関連付けられたlater_listが削除されること' do
      user.save
      create(:later_list, user: user)
      expect { user.destroy }.to change { LaterList.count }.by(-1)
    end

    it '関連付けられたlearn_templateが削除されること' do
      user.save
      create(:learn_template, user: user)
      expect { user.destroy }.to change { LearnTemplate.count }.by(-1)
    end
  end
end
