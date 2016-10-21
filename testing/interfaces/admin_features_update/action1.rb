def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  feature_id = nil
  
  it "IH928_features-update for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.put_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
  
  it "precondition: create one feature" do
    api_base.set_user_token($parameters["user"]["user_name"],$parameters["user"]["password"],true)
    feature_id = Helper::IronHideDbUtil.get_max_feature_id_by_title($parameters['precodition']["request"]['title'])
    if feature_id.nil?     
      response = api_base.post_by_api($parameters['precodition']["api_path"],$parameters['precodition']["request"]) rescue false
      Common.logger_info response
      feature_id = Helper::IronHideDbUtil.get_max_feature_id_by_title($parameters['precodition']["request"]['title'])
    end
  end
  
  it "IH929_features-update for signin test" do
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["feature_id"] = feature_id if "#{test_data["request"]["feature_id"]}" == "0"
      test_data["request"]["title"] = Helper::IronHideDbUtil.get_one_feature_title if "#{test_data["request"]["title"]}" == "0"
      response = api_base.put_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
      if test_data["expected"]["code"].to_i == 1
        test_data["request"].delete("start_time")
        test_data["request"].delete("end_time")
        test_data["request"].delete("feature_id")
        unless Helper::IronHideDbUtil.expect_db_fields?("select * from features where id='#{feature_id}'",test_data["request"])
          Common.logger_error("Check modified DB records failed!")
        end
      end
    end
  end
end
