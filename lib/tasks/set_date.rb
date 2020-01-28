LearnedContent.where(is_test: false).update_all('till_next_review = till_next_review - 1')
