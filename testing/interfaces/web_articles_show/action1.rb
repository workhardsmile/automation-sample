def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH650_articles-show for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["post_id"] = Helper::IronHideDbUtil.get_one_valid_article_id if test_data["request"]["post_id"].to_i == 0
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]['post_title']!=nil).to be_truthy if test_data["expected"]["code"].to_i == 1
    end
  end
  
  it "IH651_articles-show for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["post_id"] = Helper::IronHideDbUtil.get_one_valid_article_id if test_data["request"]["post_id"].to_i == 0
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      if test_data["expected"]["code"].to_i == 1
        expect(response["data"]['post_title']!=nil).to be_truthy
        expect(response["data"]['user']!=nil).to be_truthy
        expect(response["data"]['topics']!=nil).to be_truthy
        expect(response["data"]['comments']!=nil).to be_truthy
      end
    end
  end
end
