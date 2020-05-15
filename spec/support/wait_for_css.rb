module WaitForCss
  def wait_for_css_appear(selector, wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until has_css?(selector)
    end
    yield if block_given?
  end

  def wait_for_css_disappear(selector, wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until has_no_css?(selector)
    end
    yield if block_given?
  end

  def paginate_and_wait(page, wait_time = Capybara.default_max_wait_time)
    within('.pagination') { click_link page.to_s }
    Timeout.timeout(wait_time) do
      loop until has_selector?('.page.current', text: page.to_s)
    end
    yield if block_given?
  end
end
