def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH940_features-anchors for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
  
  it "IH941_features-anchors for signin test" do
    api_base.set_user_token($parameters["user"]["user_name"],$parameters["user"]["password"],true)
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["feature_id"] = Helper::IronHideDbUtil.get_max_feature_id_by_title if "#{test_data["request"]["feature_id"]}" == "0"
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
      expect(response["data"] != nil).to be_truthy if test_data["expected"]["code"].to_i == 1
    end
  end
end
