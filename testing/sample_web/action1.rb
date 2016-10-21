def action1
  $platform = :chrome
  # describe "This is Demo Script" do
  before(:all) do
    puts "before(:all)"
  end

  after(:all) do
    puts "after(:all)"
    WebDriver.close_browser
  end

  # before(:each) do
  # puts "before(:each)"
  # end
  #
  # after(:each) do
  # puts "after(:each)"
  # end

  it "navigate to baidu" do
    WebDriver.start_browser
    WebDriver.navigate_to_url "https://www.baidu.com"
    puts "Baidu Title = #{$driver.title}"
    Common.logger_error("failed case testing!")
  end

  it "input text and search" do
    $driver.find_element(:id, "kw").send_keys("Hello World")
    $driver.find_element(:id, "su").click
    sleep(3)
    first = $driver.find_element(:xpath, "//div[@id='content_left']/div[@id='1'][1]")
    puts first.text
  end
end