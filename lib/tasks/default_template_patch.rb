# 学習テンプレートのcreateアクションを削除したため、デフォルトを当てる
User.find_each do |user|
  next if user.learn_templates.any?

  user.set_default_template_ja
end
