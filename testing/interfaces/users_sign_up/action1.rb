def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH644_users-sign_up for unsign test" do
    redis = DatabaseRedis.new($env)
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      Helper::IronHideDbUtil.update_user_name(test_data["request"]["user_name"],"测试#{Utilities::GenerateData.get_number_string_by_length(6)}") if test_data["expected"]["code"].to_i == 1
      test_data["request"]["mobile"] = "13#{Utilities::GenerateData.get_number_string_by_length(9)}" if "#{test_data["request"]["mobile"]}" == "1"
      test_data["request"]["code"] = Helper::IronHideDbUtil.get_sms_code(1,test_data["request"]["mobile"]) if "#{test_data["request"]["code"]}" == "1"
      if test_data["expected"]["is_expire"]
        redis.expire_sms_time_by_mobile(test_data["request"]["mobile"])
        sleep(5)
      end
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
end
