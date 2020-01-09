class LearnedContentsController < ApplicationController
  def index
  end

  def new
    @learned_content = LearnedContent.new
  end

  def create
    @learned_content = current_user.learned_contents.build(learned_content_params)
    @learned_content.word_definition = WordDefinition.find_by(word: params[:learned_content][:main_word])
    respond_to do |format|
      if @learned_content.save
        @learned_content.create_related_images(params[:learned_content][:related_image])
        @learned_content.create_related_words(params[:learned_content][:related_word])
        flash[:success] = '学習が記録されました。'
        format.html { redirect_to learn_url(@learned_content) }
      else
        format.js { render 'error' }
      end
    end
  end

  def question
  end

  def answer
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def learned_content_params
    params.require(:learned_content).permit(:content, :word_category_id, :is_public, questions_attributes: [:question, :answer])
  end
end
