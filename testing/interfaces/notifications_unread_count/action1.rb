def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  api_base = ApiCallBase.new

  it "IH590_notifications-unread_count for unsign test" do
    $parameters["unsign_test"].each do |test_data|
      $step_array = $step_array << test_data
      response = api_base.get_by_api($parameters["api_path"],test_data["request"])
      Common.logger_info response
      expect(response["code"]).to eq(test_data["expected"]["code"])
      expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
      expect(response["data"]['count']).to eq(0)
    end
  end

  it "IH591_notifications-unread_count for signin test" do
    test_data = $parameters["signin_test"][0]
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    response = api_base.get_by_api($parameters["api_path"],test_data["request"])
    before_count = response["data"]['count'].to_i
    expect(response["code"]).to eq(test_data["expected"]["code"])
    expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    new_comment(api_base)
    api_base.set_user_token($parameters["user"]["mobile"],$parameters["user"]["password"])
    response = api_base.get_by_api($parameters["api_path"],test_data["request"])
    after_count = response["data"]['count'].to_i
    Common.logger_info response
    expect(response["code"]).to eq(test_data["expected"]["code"])
    expect(response["message"].strip).to eq(test_data["expected"]["message"].strip)
    expect(after_count-before_count).to eq(1)
  end
end

def new_comment(api_base)
  params = {'article_id' => '18',
    'content' => 'test_新消息',
    'comment_id' => '22'}
  api_base.set_user_token('15800000002','123456')
  response = api_base.post_by_api('/api/mobile/v1/articles/comment', params)
  return response
end
