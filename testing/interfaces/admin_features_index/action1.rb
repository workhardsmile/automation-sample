def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH924_features-index for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
  
  it "IH925_features-index for signin test" do
    api_base.set_user_token($parameters["user"]["user_name"],$parameters["user"]["password"],true)
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].include?(test_data["expected"]["message"])).to be_truthy
      if response["code"].to_i == 1
        response["data"]["list"].each do |line|
          expect(line["status"] == test_data["request"]["status"] || test_data["request"]["status"].to_i == 0).to be_truthy
        end
      end
    end
  end
end
