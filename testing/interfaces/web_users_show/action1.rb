def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH656_users-show for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "IH657_users-show for signin test" do   
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      if "#{test_data["expected"]["is_expert"]}" == "0"
        api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
      elsif "#{test_data["expected"]["is_expert"]}" == "1"
        api_base.set_user_token($parameters["export_user"]["mobile"],$parameters["export_user"]["password"])
      end
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]["is_expert"]).to eq(test_data["expected"]["is_expert"])        
    end
  end
end
