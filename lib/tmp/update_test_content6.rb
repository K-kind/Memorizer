test_admin_email = Rails.application.credentials.dig(:seed, :test_admin_email)
test_admin = User.find_by(email: test_admin_email)
question_to_update = test_admin.learned_contents[-2].questions.first
User.where('is_test_user = ? AND email != ?', true, test_admin_email).each_with_index do |user, index|
  if index > 9
    user.destroy
    next
  end
  user.learned_contents[-2].questions.first.update(
    question: question_to_update.question,
    answer: question_to_update.answer
  )
end
