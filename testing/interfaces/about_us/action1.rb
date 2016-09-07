def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH486_about-us without sign status" do
    $parameters["unsign_test"].each do |test_data|
      response = api_base.get_by_api($parameters["api_path"])
      puts response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]['content'].strip.include?(test_data["expected"]["include_content"].strip)).to be_truthy
    end
  end
  
  it "IH487_aboutus-with sign status" do
    api_base.set_user_token
    $parameters["signin_test"].each do |test_data|
      response = api_base.get_by_api($parameters["api_path"])
      puts response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]['content'].strip.include?(test_data["expected"]["include_content"].strip)).to be_truthy
    end
  end
end
