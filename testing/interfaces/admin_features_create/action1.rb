def action_1
  time_str = Time.now.strftime("%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH922_features-create for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
  
  it "IH923_features-create for signin test" do
    api_base.set_user_token($parameters["user"]["user_name"],$parameters["user"]["password"],true)
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["title"] = "专题#{time_str}" if "#{test_data["request"]["title"]}" == "1"
      Helper::IronHideDbUtil.delete_feature_by_title(test_data["request"]["title"]) if "#{test_data["expected"]["code"]}" == "1"
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
      expect(response["data"]["feature_id"] != nil).to be_truthy if "#{test_data["expected"]["code"]}" == "1"
    end
  end
end
