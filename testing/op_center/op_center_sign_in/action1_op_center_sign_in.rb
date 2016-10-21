# encoding: UTF-8
def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new

  it "IH811_登录成功" do
  # 1、输入正确的用户名密码
  # 2、点击登录
  # 登录成功，进入运营中心主页
    $parameters["success_test"].each do |test_data|
      WebDriver.restart_browser
      WebDriver.navigate_to_url(Helper::IronHideWebUtil.op_center_url)
      OpCenterCommonLogin::UserNameInput.new.wait_element_clickable
      OpCenterCommonLogin::UserNameInput.new.input(test_data["request"]["user_name"])
      OpCenterCommonLogin::PasswordInput.new.input(test_data["request"]["password"])
      OpCenterCommonLogin::LoginButton.new.click
      OpCenterCommonLogin::LoginButton.new.wait_element_disappear
      OpCenterHomeLeftLinks::FeatureLink.new.wait_element_present
    end
  end

  it "IH812_登录失败" do
  # 1
  # 1、输入错误的用户名
  # 2、输入密码
  # 3、点击登录
  # 提示用户名或密码错误，登录失败
  # 2
  # 1、用户名为空
  # 2、输入密码
  # 3、点击登录
  # 用户名不能为空，登录失败
  # 3
  # 1、输入正确的用户名
  # 2、密码为空
  # 3、点击登录
  # 密码不能为空，登录失败_browser
    WebDriver.restart_browser
    WebDriver.navigate_to_url(Helper::IronHideWebUtil.op_center_url)
    OpCenterCommonLogin::UserNameInput.new.wait_element_clickable
    $parameters["fail_test"].each do |test_data|
      OpCenterCommonLogin::UserNameInput.new.input(test_data["request"]["user_name"])
      OpCenterCommonLogin::PasswordInput.new.input(test_data["request"]["password"])
      OpCenterCommonLogin::LoginButton.new.click
      #OpCenterCommonLogin::ErrorMessageText.new.wait_element_present
      OpCenterCommonLogin::ErrorMessageByIncludeText.new(test_data["expected"]["message"]).wait_element_present
    end
  end
  
  it "clear and restore" do
    WebDriver.stop_browser
  end
end
