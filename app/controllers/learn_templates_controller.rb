class LearnTemplatesController < ApplicationController
  before_action :logged_in_user, only: [:update, :default]
  before_action :set_learn_template

  def update
    if @learn_template.update(learn_template_params)
      @message = '学習テンプレートを更新しました。'
    else
      @message = @learn_template.errors.full_messages.join('\n')
      render 'error'
    end
  end

  def default
    content =
      case params[:lang]
      when 'ja'
        LearnTemplate::DEFAULT_JA
      when 'en'
        LearnTemplate::DEFAULT_EN
      end
    @learn_template.update!(content: content)
    @message = '学習テンプレートをデフォルトに設定しました。'
  end

  def show; end

  private

  def learn_template_params
    params.require(:learn_template).permit(:content)
  end

  def set_learn_template
    @learn_template = LearnTemplate.find(params[:id])
  end
end
