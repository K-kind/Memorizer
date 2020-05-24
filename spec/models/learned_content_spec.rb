require 'rails_helper'

RSpec.describe LearnedContent, type: :model do
  describe 'learned_contentの作成や削除' do
    let(:user) { create(:user) }
    let(:word_definition) { create(:word_definition) }
    let(:learned_content) {
      create(:learned_content,
             word_definition_id: word_definition.id,
             user: user)
    }
    let(:learned_content_with_question) { create(:learned_content, :with_question) }

    it 'learned_contentが有効であること' do
      expect(learned_content).to be_valid
    end

    it 'user_idがないlearned_contentは無効であること' do
      learned_content.user = nil
      expect(learned_content).to be_invalid
    end

    it 'word_category_idがないlearned_contentは無効であること' do
      learned_content.word_category = nil
      expect(learned_content).to be_invalid
    end

    it 'word_defitinion_idがないlearned_contentは無効であること' do
      learned_content.word_definition = nil
      expect(learned_content).to be_invalid
    end

    it 'calendar_idがないlearned_contentは無効であること' do
      learned_content.calendar = nil
      expect(learned_content).to be_invalid
    end

    it 'contentがないlearned_contentも有効であること' do
      learned_content.content = nil
      expect(learned_content).to be_valid
    end

    it 'contentが3000文字以内ならば有効であること' do
      # trixのタグなどを除いて2963文字
      learned_content.content = 'a' * 2963
      expect(learned_content).to be_valid
    end

    it 'contentが3001文字以上ならば無効であること' do
      learned_content.content = 'a' * 2964
      expect(learned_content).to be_invalid
    end

    it 'importedがtrueならばis_public:trueは無効であること' do
      learned_content.imported = true
      learned_content.is_public = true
      learned_content.valid?
      expect(learned_content.errors[:base]).to include('ダウンロードされたコンテンツは公開できません。')
    end

    it 'questionがなければ無効であること' do
      learned_content_with_question.questions.destroy_all
      learned_content_with_question.valid?(:self_learn)
      expect(learned_content_with_question.errors[:base]).to include('1つ以上の問題を入力してください。')
    end

    it 'questionがあれば有効であること' do
      expect(learned_content_with_question.valid?(:self_learn)).to be true
    end

    it '関連画像が3枚以内ならば有効であること' do
      # 実装の都合上4
      4.times do
        create(:related_image,
               learned_content: learned_content_with_question)
      end
      learned_content_with_question.reload
      expect(learned_content_with_question.valid?(:self_learn)).to be true
    end

    it '関連画像が4枚以上ならば無効であること' do
      5.times do
        create(:related_image,
               learned_content: learned_content_with_question)
      end
      learned_content_with_question.reload
      learned_content_with_question.valid?(:self_learn)
      expect(learned_content_with_question.errors[:base]).to include('画像は3枚まで保存できます。')
    end

    it '関連付けられたquestionsが削除されること' do
      create(:question, learned_content: learned_content)
      learned_content.reload
      expect { learned_content.destroy }.to change { Question.count }.by(-1)
    end

    it '関連付けられたrelated_wordsが削除されること' do
      create(:related_word, learned_content: learned_content, word_definition_id: word_definition.id)
      expect { learned_content.destroy }.to change { RelatedWord.count }.by(-1)
    end

    it '関連付けられたrelated_imagesが削除されること' do
      create(:related_image, learned_content: learned_content)
      learned_content.reload
      expect { learned_content.destroy }.to change { RelatedImage.count }.by(-1)
    end
  end
end
