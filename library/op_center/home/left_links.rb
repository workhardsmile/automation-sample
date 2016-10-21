# encoding: UTF-8
module OpCenterHomeLeftLinks
  class FeatureLink < Link
    def initialize
      Link.new("xpath","//ul[@id='nav']//a[contains(.,'专题管理')]")
    end
  end
  
  class FeatureListLink < Link
    def initialize
      Link.new("xpath","//ul[@id='nav']//a[contains(.,'专题列表')]")
    end
  end
  
  class AddFeatureLink < Link
    def initialize
      Link.new("xpath","//ul[@id='nav']//a[contains(.,'添加专题')]")
    end
  end
end