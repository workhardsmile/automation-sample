#load all the common functions
# Dir[File.dirname(__FILE__) + '/../common/*.rb'].each {|file| require file if file!="./"<<__FILE__}
Dir[File.dirname(__FILE__) + '/../common/*/**/*.rb'].each {|file| require file if file!="./"<<__FILE__}
#load all the libraries under ../library
#Dir.glob("#{File.dirname(__FILE__)}/../library/*/*.rb").each{|f| require f}
Dir.glob("#{File.dirname(__FILE__)}/../library/*/**/*.rb").each{|f| require f}
#load all the libraries under ../workflow
#Dir.glob("#{File.dirname(__FILE__)}/../workflow/*/*.rb").each{|f| require f}
Dir.glob("#{File.dirname(__FILE__)}/../workflow/*/**/*.rb").each{|f| require f}

name='web_articles_author_articles'
$parameters=YAML.load(File.open("#{File.dirname(__FILE__)}/interfaces/#{name}/config.yml"))
paths = $parameters["api_path"].split('/')
puts "#{paths[-2]}-#{paths.last} for unsign test"
steps = expects = ""
($parameters["unsign_test"]||[]).each_with_index do |test_data,index|
steps +="#{index+1}. #{test_data['request'].to_json}\n"
expects +="#{index+1}. #{test_data['expected'].to_json}\n"
end
puts $parameters["api_path"],steps,expects
puts "##########################################################"
puts "#{paths[-2]}-#{paths.last} for signin test"
steps = expects = ""
($parameters["signin_test"]||[]).each_with_index do |test_data,index|
steps +="#{index+1}. #{test_data['request'].to_json}\n"
expects +="#{index+1}. #{test_data['expected'].to_json}\n"
end
puts $parameters["api_path"],steps,expects
# phone = Utilities::GenerateData.get_number_string_by_length(10)
# # sql = "select * from users where mobile = '15982326275'"
# # puts DatabaseMysql.new("QA").query(sql)
# # sql = "UPDATE users SET mobile = '1#{phone}' WHERE mobile = '15982326275'"
# # puts DatabaseMysql.new("QA").query(sql)
# redis = DatabaseRedis.get_redis("QA")
# #redis.set('str',1)
# redis.del("sms:register:success_count:15982326275")
# redis.del("sms:forget_password:success_count:15982326275")

# WebDriver.start_browser({'device' => 'android_simulator'})
# more_button = Button.new("xpath","//android.widget.ImageView")
# #more_button = $appium_driver.find_elements(:xpath,"//android.widget.ImageView").last
# #$appium_driver.execute_script 'mobile: tap', :x => 0.0, :y => 0.98
# more_button.click
# # $appium_driver.driver_quit rescue nil
