RSpec.congigure do |config|
  config.before(:each, type: :system) do
    driven_by(:selenium_chrome_headless)
  end
end
