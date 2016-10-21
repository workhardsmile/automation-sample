# encoding: UTF-8
def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  valid_article_id = Helper::IronHideDbUtil.get_one_valid_article_id #_by_mobile($parameters["user"]["mobile"])

  it "IH562_articles-comments without sign status" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["article_id"] = valid_article_id if test_data["request"]["article_id"].to_i == 0
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      if test_data["expected"]["code"].to_i == 1
        test_data["request"]["per"] = 10 if test_data["request"]["per"].nil?
        expect(response["data"]["list"].length<=test_data["request"]["per"].to_i).to be_truthy
        case "#{test_data["request"]["sort"]}"
        #默认排序-时间
        when "0"
          response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["created_at"]>=list["created_at"]).to be_truthy if index>0}
        #点赞排序
        when "1"
          response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["vote_count"]>=list["vote_count"]).to be_truthy if index>0}
        #评论排序
        when "2"
          response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["comment_count"]>=list["comment_count"]).to be_truthy if index>0}
        end
      end
    end
  end

  it "IH563_articles-comments with sign status" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      test_data["request"]["article_id"] = valid_article_id if test_data["request"]["article_id"].to_i == 0
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      if test_data["expected"]["code"].to_i == 1
        test_data["request"]["per"] = 10 if test_data["request"]["per"].nil?
        expect(response["data"]["list"].length<=test_data["request"]["per"].to_i).to be_truthy
        case "#{test_data["request"]["sort"]}"
        #默认排序-时间
        when "0"
          response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["created_at"]>=list["created_at"]).to be_truthy if index>0}
        #点赞排序
        when "1"
          response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["vote_count"]>=list["vote_count"]).to be_truthy if index>0}
        #评论排序
        when "2"
          response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["comment_count"]>=list["comment_count"]).to be_truthy if index>0}
        end
      end
    end
  end
end