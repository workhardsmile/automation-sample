def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH488_articles-comment without sign status" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
    end
  end
  
  it "IH489_articles-comment with sign status" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      if test_data["request"]["article_id"].to_i == 0
        test_data["request"]["article_id"] = Helper::IronHideDbUtil.get_one_valid_article_id_unless_mobile($parameters["user"]["mobile"])
      elsif test_data["request"]["article_id"].to_i == -1
        test_data["request"]["article_id"] = Helper::IronHideDbUtil.get_one_valid_article_id_by_mobile($parameters["user"]["mobile"])
      end
      if test_data["request"]["comment_id"].nil?
      elsif test_data["request"]["comment_id"].to_i == 0
        test_data["request"]["comment_id"] = Helper::IronHideDbUtil.get_one_valid_comment_id_unless_mobile($parameters["user"]["mobile"],test_data["request"]["article_id"])
      elsif test_data["request"]["comment_id"].to_i == -1
        test_data["request"]["comment_id"] = Helper::IronHideDbUtil.get_one_valid_comment_id_by_mobile($parameters["user"]["mobile"],test_data["request"]["article_id"])
      elsif test_data["request"]["comment_id"].to_i == -2
        test_data["request"]["comment_id"] = Helper::IronHideDbUtil.get_one_valid_comment_id_unless_mobile_unless_article($parameters["user"]["mobile"],test_data["request"]["article_id"])
      end
      response = api_base.post_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"]).to eq(test_data["expected"]["message"])
      expect(response["data"]["content"]).to eq(test_data["request"]["content"]) if test_data["expected"]["code"].to_i==1
    end
  end
end
