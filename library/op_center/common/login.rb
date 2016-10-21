module OpCenterCommonLogin
  class UserNameInput < TextInput
    def initialize
      TextInput.new("id","username")
    end
  end
  
  class PasswordInput < TextInput
    def initialize
      TextInput.new("id","password")
    end
  end
  
  class LoginButton < Button
    def initialize
      Button.new("xpath","//button[@type='submit']")
    end
  end
  
  class ErrorMessageText < Text
    def initialize
      Text.new("xpath","//div[contains(@class,'error')]")
    end
  end
  
  class ErrorMessageByIncludeText < Text
    def initialize(include_text=nil)
      Text.new("xpath","//div[contains(@class,'error')][contains(.,'#{include_text}')]")
    end
  end
end
