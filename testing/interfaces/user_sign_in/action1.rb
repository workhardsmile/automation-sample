def action_1
  time_str = Time.now.strftime("%Y%m%d%H%M%S")
  
  it "IH001_sign-in" do
    $parameters["signin_test"].each do |test_data|
      user,token = ApiCallBase.get_user_token(test_data["request"]["mobile"],test_data["request"]["password"])
      Common.logger_info(user)
      expect(user["code"]).to eq(test_data["expected"]["code"])
      expect(user["message"].strip).to eq(test_data["expected"]["message"].strip)    
    end
  end
end
