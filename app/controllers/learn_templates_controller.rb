class LearnTemplatesController < ApplicationController
  before_action :logged_in_user

  def create
    @learn_template = current_user.learn_templates.build(learn_template_params)
    if @learn_template.save
      @message = '学習テンプレートを作成しました。'
    else
      render 'error'
    end
  end

  def update
    @learn_template = current_user.learn_templates.first
    if @learn_template.update(learn_template_params)
      @message = '学習テンプレートを更新しました。'
      render 'create'
    else
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
