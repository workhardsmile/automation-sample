def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH658_users-sign_in for signin test" do
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info(response)
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)   
      expect(response["data"]["is_expert"]).to eq(test_data["expected"]["is_expert"])  unless test_data["expected"]["is_expert"].nil?
    end
  end
end
