def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH566_articles-empty_favorites for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.delete_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "IH567_articles-empty_favorites for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.delete_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
end
