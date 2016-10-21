def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH592_users-random_username for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]['user_name'].length >= 2 && response["data"]['user_name'].length <= 11).to be_truthy
    end
  end
  
  it "IH593_users-random_username for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]['user_name'].length >= 2 && response["data"]['user_name'].length <= 11).to be_truthy
    end
  end
end
