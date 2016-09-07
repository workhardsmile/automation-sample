def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new

  it "IH490_articles-list without sign status" do
    $parameters["unsign_test"].each do |test_data|
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      #puts response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      case "#{test_data["request"]["sort"]}"
      when "0"
        #response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["created_at"]>=list["created_at"]).to be_truthy if index>0}
      when "1"
        response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["vote_count"]>=list["vote_count"]).to be_truthy if index>0}
      when "2" 
        response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["comment_count"]>=list["comment_count"]).to be_truthy if index>0}
      end
    end
  end

  it "IH491_articles-list with sign status" do
    api_base.set_user_token
    $parameters["signin_test"].each do |test_data|
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      #puts response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      case "#{test_data["request"]["sort"]}"
      when "0"
        #response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["created_at"]>=list["created_at"]).to be_truthy if index>0}
      when "1"
        response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["vote_count"]>=list["vote_count"]).to be_truthy if index>0}
      when "2" 
        response["data"]["list"].each_with_index {|list,index| expect(response["data"]["list"][index-1]["comment_count"]>=list["comment_count"]).to be_truthy if index>0}
      end
    end
  end
end
