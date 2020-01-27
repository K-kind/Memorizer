require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'questionの作成や削除' do
    let(:question) { build(:question) }

    it 'questionが有効であること' do
      expect(question).to be_valid
    end

    it 'learned_contentがなければ無効であること' do
      question.learned_content = nil
      expect(question).to be_invalid
    end

    it 'questionとanswerがどちらも空のときは有効であること' do
      question.question = nil
      question.answer = nil
      expect(question).to be_valid
    end

    it 'questionのみが空のときは無効であること' do
      question.question = nil
      expect(question).to be_invalid
    end

    it 'answerのみが空のときは無効であること' do
      question.question = nil
      expect(question).to be_invalid
    end

    it '1001文字以上のquestionは無効であること' do
      question.question = 'a' * 1001
      expect(question).to be_invalid
    end

    it '256文字以上のanswerは無効であること' do
      question.answer = 'a' * 256
      expect(question).to be_invalid
    end

    it 'context: :questionではmy_answerがなければ無効であること' do
      expect(question).to be_invalid(:question)
    end

    it 'context: :questionで255文字以内のmy_answerは有効であること' do
      question.my_answer = 'a' * 255
      expect(question).to be_valid(:question)
    end

    it 'answerとmy_answerが完全一致ならばcalculate_similarityは100を返すこと' do
      question.answer = 'memorizer'
      question.my_answer = 'memorizer'
      expect(question.calculate_similarity).to eq(100)
    end
  end
end
