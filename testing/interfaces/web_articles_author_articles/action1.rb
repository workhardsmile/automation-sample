def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  valid_article_id = Helper::IronHideDbUtil.get_one_valid_article_id
  
  it "IH956_articles-author_articles for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["post_id"] = valid_article_id if test_data["request"]["post_id"].to_i == 0
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "IH957_articles-author_articles for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["post_id"] = valid_article_id if test_data["request"]["post_id"].to_i == 0
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
end
