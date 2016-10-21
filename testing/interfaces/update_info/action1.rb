def action_1
  api_base = ApiCallBase.new
  redis = DatabaseRedis.new($env)  
  
  it "IH636_settings-uptoken for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.put_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)     
    end
  end
  
  it "IH635_settings-update_info for signin test" do
    redis = DatabaseRedis.new($env)
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    userid = Helper::IronHideDbUtil.get_userid_by_mobile($parameters["user"]["mobile"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      if redis.get_username_status_by_userid(userid) && test_data["expected"]["state"].nil?
        redis.del_update_username_by_userid(userid)
      end
      if "#{test_data["request"]["user_name"]}" == "-1"
        test_data["request"]["user_name"] = Helper::IronHideDbUtil.get_user_row_unless_mobile($parameters["user"]["mobile"])["user_name"]
      elsif "#{test_data["request"]["user_name"]}" == "1"
        test_data["request"]["user_name"] = "test#{Time.now.strftime("%M%S")}#{rand(10)}" 
      end      
      response = api_base.put_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      if test_data["expected"]["signature"] != nil
        expect(response["data"]['signature'].strip).to eq(test_data["expected"]["signature"].strip)
      elsif test_data["expected"]["gender"] != nil
        expect(response["data"]['gender'].to_i).to eq(test_data["expected"]["gender"].to_i)
      elsif test_data["expected"]["avatar"] != nil
        expect(response["data"]['avatar'].strip).to eq(test_data["expected"]["avatar"].strip)
      end        
    end
  end
end
