class ConsultedWordsController < ApplicationController
  before_action :logged_in_user
  before_action :no_always_dictionary, only: [:index]
  before_action :set_consulted_words

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    ConsultedWord.find(params[:id]).destroy
    render 'index'
  end

  private

  def set_consulted_words
    @consulted_words = current_user.consulted_words.order(id: 'DESC').page(params[:page])
  end
end
