def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  feature_id = nil
  
  it "IH936_features-create_anchor for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
  
  it "precondition: create one feature" do
    api_base.set_user_token($parameters["user"]["user_name"],$parameters["user"]["password"],true)
    Helper::IronHideDbUtil.delete_feature_by_title($parameters['precodition']["request"]['title'])
    response = api_base.post_by_api($parameters['precodition']["api_path"],$parameters['precodition']["request"]) rescue false
    Common.logger_info response
    feature_id = Helper::IronHideDbUtil.get_max_feature_id_by_title($parameters['precodition']["request"]['title'])
  end
  
  it "IH937_features-create_anchor for signin test" do
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["feature_id"] = feature_id if "#{test_data["request"]["feature_id"]}" == "0"
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
      expect(response["data"]["anchor_id"] != nil).to be_truthy if test_data["expected"]["code"].to_i == 1
    end
  end
end
