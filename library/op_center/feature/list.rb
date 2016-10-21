# encoding: UTF-8
module OpCenterFeatureList
  class FeatureNameInput < TextInput
    def initialize
      TextInput.new("xpath","//div[@class='form-inline']/div[@class='form-group'][1]//input")
    end
  end
  
  class StateDropList < DropdownMenu
    def initialize
      DropdownMenu.new("xpath","//div[@class='form-inline']/div[@class='form-group'][2]//div[@class='dropdown']")
    end
  end
  
  class SearchButton < Button
    def initialize
      Button.new("xpath","//div[@class='form-inline']/button[@type='button']")
    end
  end
  
  class ResetButton < Button
    def initialize
      Button.new("xpath","//div[@class='form-inline']/button[@type='reset']")
    end
  end
  
  class FeatureListTable < Table
    def initialize
      Table.new("xpath","//div[@class='item-main']/table")
    end
  end
end