# 学習テンプレートのcreateアクションを削除したため、デフォルトを当てる
User.find_each do |user|
  next if user.learn_templates.any?

  user.learn_templates.create!(
    content: LearnTemplate::DEFAULT_JA
  )
end
