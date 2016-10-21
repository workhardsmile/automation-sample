module Helper
  module IronHideWebUtil
    WEB_URL=YAML.load(File.open("#{File.dirname(__FILE__)}/../../data/webserver_url.yml"))
    class << self
      def op_center_url
        op_center_url = WEB_URL[$env]["OP-Center"]
      end
      
      def mobile_web_url
        mobile_web_url = WEB_URL[$env]["MobileWeb"]
      end
      
      def pc_web_url
        pc_web_url = WEB_URL[$env]["PC-Web"]
      end
    end
  end
end