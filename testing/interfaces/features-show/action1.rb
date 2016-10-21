def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH646_features-show for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["expected"]["feature_id"] = test_data["request"]["feature_id"] = Helper::IronHideDbUtil.get_one_valid_feature_id if "#{test_data["request"]["feature_id"]}" == "0" 
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]["feature_id"]).to eq(test_data["expected"]["feature_id"]) unless test_data["expected"]["feature_id"].nil?
    end
  end
  
  it "IH647_features-show for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["expected"]["feature_id"] = test_data["request"]["feature_id"] = Helper::IronHideDbUtil.get_one_valid_feature_id if "#{test_data["request"]["feature_id"]}" == "0" 
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]["feature_id"]).to eq(test_data["expected"]["feature_id"]) unless test_data["expected"]["feature_id"].nil?
    end
  end
end
