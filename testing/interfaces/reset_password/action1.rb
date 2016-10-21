def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")  
  api_base = ApiCallBase.new
  sms_code = nil
  
  it "IH596_settings-reset_password for unsign test" do
    sms_code = Helper::IronHideDbUtil.get_sms_code('update',$parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["mobile"] = $parameters["user"]["mobile"]
      test_data["request"]["code"] = sms_code if "#{test_data["request"]["code"]}" == ""
      response = api_base.put_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "IH597_settings-reset_password for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["mobile"] = $parameters["user"]["mobile"]
      test_data["request"]["code"] = sms_code if "#{test_data["request"]["code"]}" == ""
      response = api_base.put_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "clear and restore" do
    Helper::IronHideDbUtil.reset_sms_by_mobile($parameters["user"]["mobile"])
  end
end
