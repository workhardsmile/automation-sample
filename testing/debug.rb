#load all the common functions
# Dir[File.dirname(__FILE__) + '/../common/*.rb'].each {|file| require file if file!="./"<<__FILE__}
Dir[File.dirname(__FILE__) + '/../common/*/**/*.rb'].each {|file| require file if file!="./"<<__FILE__}
#load all the libraries under ../library
#Dir.glob("#{File.dirname(__FILE__)}/../library/*/*.rb").each{|f| require f}
Dir.glob("#{File.dirname(__FILE__)}/../library/*/**/*.rb").each{|f| require f}
#load all the libraries under ../workflow
#Dir.glob("#{File.dirname(__FILE__)}/../workflow/*/*.rb").each{|f| require f}
Dir.glob("#{File.dirname(__FILE__)}/../workflow/*/**/*.rb").each{|f| require f}
# name='articles_list'
# $parameters=YAML.load(File.open("#{File.dirname(__FILE__)}/interfaces/#{name}/config.yml"))
# puts "#{$parameters["api_path"].split('/').last} for unsign test"
# steps = expects = ""
# ($parameters["unsign_test"]||[]).each_with_index do |test_data,index|
  # steps +="#{index+1}. #{test_data['request'].to_json}\n"
  # expects +="#{index+1}. #{test_data['expected'].to_json}\n"
# end
# puts $parameters["api_path"],steps,expects
# puts "##########################################################"
# puts "#{$parameters["api_path"].split('/').last} for signin test"
# steps = expects = ""
# ($parameters["signin_test"]||[]).each_with_index do |test_data,index|
  # steps +="#{index+1}. #{test_data['request'].to_json}\n"
  # expects +="#{index+1}. #{test_data['expected'].to_json}\n"
# end
# puts $parameters["api_path"],steps,expects
phone = Utilities::GenerateData.get_number_string_by_length(11)
sql = "select * from users where mobile = '15982326275'"
puts DatabaseMysql.new("QA").query(sql)
# sql = "UPDATE users SET mobile = '#{phone}' WHERE mobile = '15982326275'"
# puts DatabaseMysql.new("QA").query(sql)
