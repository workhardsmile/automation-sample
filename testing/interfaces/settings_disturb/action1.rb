def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  userid = redis = nil
  
  it "IH600_settings-disturb for unsign test" do   
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "IH601_settings-disturb for signin test" do
    userid = Helper::IronHideDbUtil.get_userid_by_mobile($parameters["user"]["mobile"])
    redis = DatabaseRedis.get_redis($env)
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      if test_data["request"]["type"].to_i == 0
        expect(redis.get("user:disturb:#{userid}").to_i).to eq(0)
      elsif test_data["request"]["type"].to_i == 1
        expect(redis.get("user:disturb:#{userid}").to_i).to eq(1)
      end
    end
  end
end
