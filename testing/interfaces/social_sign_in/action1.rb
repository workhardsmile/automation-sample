def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH643_users-social_sign_in for unsign test" do
    user_row = Helper::IronHideDbUtil.get_user_row_by_mobile($parameters["user"]["mobile"])
    $parameters["unsign_test"].each do |test_data|
      if "#{test_data['request']['openid']}" == "1"
        test_data['request']['openid'] = Utilities::GenerateData.get_number_string_by_length(10)
      end
      if "#{test_data['request']['user_name']}" == "1"
        test_data['request']['user_name'] = "#{test_data["expected"]["user_name"]}#{Utilities::GenerateData.get_number_string_by_length(10)}"
      elsif "#{test_data['request']['user_name']}" == "2"
        test_data["expected"]["user_name"] = test_data['request']['user_name'] = user_row["user_name"]
      end
      $step_array = $step_array << test_data 
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
      unless test_data["expected"]["user_name"].nil?
        expect(response["data"]["user_name"].include?(test_data["expected"]["user_name"][0..-2])).to be_truthy
        expect(response["data"]["user_name"].length<=10).to be_truthy
      end
    end
  end
end
