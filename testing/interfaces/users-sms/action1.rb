def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  redis = DatabaseRedis.new($env)
  
  it "IH602_users-sms for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      if "#{test_data["request"]['mobile']}" == ""
        test_data["request"]['mobile'] = "180#{Utilities::GenerateData.get_number_string_by_length(8)}"
      end
      if test_data["request"]['get_count'].to_i >= 10
        redis.set_success_count_by_type_and_mobile(test_data["request"]['type'],test_data["request"]['mobile'],test_data["request"]['get_count'])
        sleep(1)
      end
      if test_data["request"]['error_count'].to_i >= 5
        redis.set_error_count_by_type_and_mobile(test_data["request"]['type'],test_data["request"]['mobile'],test_data["request"]['error_count'])
        sleep(1)
      end
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      redis.reset_sms_by_mobile(test_data["request"]['mobile'])
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "IH603_users-sms for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      if "#{test_data["request"]['mobile']}" == ""
        test_data["request"]['mobile'] = "180#{Utilities::GenerateData.get_number_string_by_length(8)}"
      end
      if test_data["request"]['get_count'].to_i >= 10
        redis.set_success_count_by_type_and_mobile(test_data["request"]['type'],test_data["request"]['mobile'],test_data["request"]['get_count'])
        sleep(1)
      end
      if test_data["request"]['error_count'].to_i >= 5
        redis.set_error_count_by_type_and_mobile(test_data["request"]['type'],test_data["request"]['mobile'],test_data["request"]['error_count'])
        sleep(1)
      end
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      redis.reset_sms_by_mobile(test_data["request"]['mobile'])
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
end
