# encoding: UTF-8
def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new
  
  it "IH654_users-articles for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    end
  end
  
  it "IH655_users-articles for signin test" do
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      case "#{test_data["request"]["sort"]}"
      #默认排序-时间
      when "0"
        response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["created_at"]>=list["created_at"]).to be_truthy if index>0&&response["data"]["list"][index-1]["post_type"].to_i==1}
      #点赞排序
      when "1"
        response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["vote_count"]>=list["vote_count"]).to be_truthy if index>0&&response["data"]["list"][index-1]["post_type"].to_i==1}
      #评论排序
      when "2" 
        response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["comment_count"]>=list["comment_count"]).to be_truthy if index>0&&response["data"]["list"][index-1]["post_type"].to_i==1}
      end
    end
  end
end
