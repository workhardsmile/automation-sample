def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  anchor_id1 = anchor_id2 = articles_list = topics_list = nil
  
  it "IH944_features-save_anchor_data for unsign test" do
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
    $parameters['precodition'][2]["request"]['feature_id'] = $parameters['precodition'][1]["request"]['feature_id'] = Helper::IronHideDbUtil.get_max_feature_id_by_title($parameters['precodition'][0]["request"]['title'])
    response = api_base.post_by_api($parameters['precodition'][1]["api_path"],$parameters['precodition'][1]["request"]) rescue false
    Common.logger_info response
    anchor_id1 = response["data"]["anchor_id"]
    response = api_base.post_by_api($parameters['precodition'][2]["api_path"],$parameters['precodition'][2]["request"]) rescue false
    Common.logger_info response
    anchor_id2 = response["data"]["anchor_id"]
    response = api_base.get_by_api($parameters['precodition'][3]["api_path"],$parameters['precodition'][3]["request"]) rescue false
    Common.logger_info response
    articles_list = response["data"]["list"]
    response = api_base.get_by_api($parameters['precodition'][4]["api_path"],$parameters['precodition'][4]["request"]) rescue false
    Common.logger_info response
    topics_list = response["data"]["list"]
  end
  
  it "IH945_features-save_anchor_data for signin test" do
    topic_ids = topics_list.reduce(""){|result,list| "#{result},#{list["post_id"]}=#{list["post_type"]}"}[1..-1]
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["feature_id"] = $parameters['precodition'][1]["request"]['feature_id'] if "#{test_data["request"]["feature_id"]}" == "0"
      test_data["request"]["data"] = "#{anchor_id1}:#{articles_list[0]["post_id"]}=#{articles_list[0]["post_type"]},#{topics_list[0]["post_id"]}=#{topics_list[0]["post_type"]}|#{anchor_id2}:#{topic_ids}" if "#{test_data["request"]["data"]}" == "0"
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
end
