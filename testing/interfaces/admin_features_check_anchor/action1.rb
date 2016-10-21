def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH942_features-check_anchor for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
  
  it "precondition: create one feature and anchor" do
    api_base.set_user_token($parameters["user"]["user_name"],$parameters["user"]["password"],true)
    Helper::IronHideDbUtil.delete_feature_by_title($parameters['precodition'][0]["request"]['title'])
    response = api_base.post_by_api($parameters['precodition'][0]["api_path"],$parameters['precodition'][0]["request"]) rescue false
    Common.logger_info response
    $parameters['precodition'][1]["request"]['feature_id'] = Helper::IronHideDbUtil.get_max_feature_id_by_title($parameters['precodition'][0]["request"]['title'])
    response = api_base.post_by_api($parameters['precodition'][1]["api_path"],$parameters['precodition'][1]["request"]) rescue false
    Common.logger_info response
  end
  
  it "IH943_features-check_anchor for signin test" do
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["feature_id"] = $parameters['precodition'][1]["request"]['feature_id'] if "#{test_data["request"]["feature_id"]}" == "0"
      test_data["request"]["name"] = $parameters['precodition'][1]["request"]['name'] if "#{test_data["request"]["name"]}" == "0"
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
end
