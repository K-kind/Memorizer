class LearnTemplatesController < ApplicationController
  before_action :logged_in_user

  def update
    @learn_template = current_user.learn_templates.last
    if @learn_template.update(learn_template_params)
      @message = '学習テンプレートを更新しました。'
    else
      @message = @learn_template.errors.full_messages.join('\n')
      render 'error'
    end
  end

  def show
    @learn_template = LearnTemplate.find(params[:id])
  end

  private

  def learn_template_params
    params.require(:learn_template).permit(:content)
  end
end
