require 'rails_helper'

RSpec.describe LearnedContent, type: :model do
  describe 'learned_contentの作成や削除' do
    let(:user) { create(:user) }
    let(:word_definition) { create(:word_definition) }
    let(:learned_content) {
      build(:learned_content,
            word_definition_id: word_definition.id,
            user: user)
    }

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

    it 'contentが3001文字以上ならば無効であること' do
      learned_content.content = 'a' * 3001
      expect(learned_content).to be_invalid
    end

    it 'importedがtrueならばis_public:trueは無効であること' do
      learned_content.imported = true
      learned_content.is_public = true
      learned_content.valid?
      expect(learned_content.errors[:base]).to include('ダウンロードされたコンテンツは公開できません。')
    end

    it '関連付けられたquestionsが削除されること' do
      learned_content.save
      create(:question, learned_content: learned_content)
      expect { learned_content.destroy }.to change { Question.count }.by(-1)
    end

    it '関連付けられたrelated_wordsが削除されること' do
      learned_content.save
      create(:related_word, learned_content: learned_content, word_definition_id: word_definition.id)
      expect { learned_content.destroy }.to change { RelatedWord.count }.by(-1)
    end
  end
end
