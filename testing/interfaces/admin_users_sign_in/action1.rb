def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  
  it "IH915_users-sign_in for unsign test" do
    $parameters["signin_test"].each do |test_data|
      $step_array = $step_array << test_data
      user,token = ApiCallBase.get_admin_user_token(test_data["request"]["user_name"],test_data["request"]["password"])
      Common.logger_info(user)
      expect(user["code"]).to eq(test_data["expected"]["code"])
      expect(user["message"].strip).to eq(test_data["expected"]["message"].strip)  
      expect(user["data"]["user_name"].strip).to eq(test_data["request"]["user_name"]) if test_data["expected"]["code"].to_i == 1
    end
  end
end
