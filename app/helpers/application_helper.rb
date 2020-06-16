module ApplicationHelper
  def full_title(page_title = nil)
    base_title = 'Memorizer'
    page_title ? "#{base_title} #{page_title}" : base_title
  end
end
