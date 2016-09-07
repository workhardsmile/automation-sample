def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH488_articles-comment without sign status" do
    $parameters["unsign_test"].each do |test_data|
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      puts response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
    Common.logger_error("ERROR Test")
  end
  
  it "IH489_articles-comment with sign status" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      puts response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      if "#{test_data["expected"]["message"]}" != ""
        expect(response["message"]).to eq(test_data["expected"]["message"])
      elsif "#{test_data["expected"]["uid"]}" != ""
        expect(response["data"]["at_user"]["user_id"]).to eq(test_data["expected"]["uid"])
      else
        expect(response["data"]["content"]).to eq(test_data["request"]["content"])
      end
    end
  end
end
