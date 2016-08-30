# encoding: UTF-8
require 'yaml'
require 'rspec'
require 'rspec/expectations'
require 'rspec/autorun'
require "optparse"

#set up the environment for automation tasks
#hash to hold all options
options = Hash.new
#handle options and arguments
optparse = OptionParser.new do|opts|
  #set the banner
  opts.banner = "Usage: ruby run.rb -s <script_path> [options]"
  #define script path option
  options[:script_path] = nil
  opts.on('-s', '--script_path <string>',
  'Name of the market to target (required)', 'ex - "camps/bvt/workflow-1", "endurance/regression/workflow-1"') do|script_path|
    options[:script_path] = script_path
  end
  
  #define threads_number option
  options[:username] = '15982326275'
  opts.on('-u', '--username <string>',
  'Account of user (optinal)', 'ex - "15982326275", "13880263305"',"Set to 15982326275 by default ") do |username|
    options[:username] = username
  end
  
  #define threads_number option
  options[:password] = '12345678'
  opts.on('-p', '--password <string>',
  'Password of user (optinal)', 'ex - "12345678", "11111111"',"Set to 12345678 by default ") do |password|
    options[:password] = password
  end
  
  #define environment option
  options[:environment] = 'QA'
  opts.on('-e', '--environment <string>', ["QA","REG", "PROD"],
  'Name of the test environment (optinal)','ex - "QA","REG", "PROD"','Set to QA by default') do|environment|
    options[:environment] = environment
  end
  
  #define round option
  options[:round] = '1234'
  opts.on('-r', '--round <string>',
  'ID of the test round (optinal)', 'ex - "9999", "8888", "7777"',"Used by Marquee client only, set to 1234 by default ") do|round|
    options[:round] = round
  end

  options[:debug] = false
  opts.on('-d','--debug','show the script result to console') do
    options[:debug] = true
  end

  #define help option
  opts.on_tail("-h", "--help", "Show options help") do
    puts opts
    exit
  end
end

begin
  #parse the command line
  optparse.parse!
  #provide friendy output on missing switches
  mandatory = [:script_path]
  missing = mandatory.select{ |param| options[param].nil? }
  if not missing.empty?
    puts("MISSING OPTIONS: #{missing.join(', ')}")
    puts(optparse)
    exit(1)
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument, OptionParser::InvalidArgument
  puts($!.to_s)
  puts(optparse)
  exit(1)
end

script_path = options[:script_path].gsub('\\\\','/').gsub('\\','/')
$plan_name=script_path.split('/').last
$username= options[:username]
$password=options[:password]
$env=options[:environment]
$round_id= options[:round]

#start date
puts "==============Start to testing #{script_path} at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
if options[:debug]
  ARGV.push '-fd'
  require 'pry'
  require 'pry-debugger'
else
  result_path = "#{$plan_name}_#{Time.now.strftime("%Y%m%d_%H%M%S")}_#{Time.now.utc.to_i}#{("%03d" % rand(999))}"
  ARGV.push '-fh'
  ARGV.push '-o'
  ARGV.push "../output/test_results/#{result_path}.htm"
  puts "You can find test result in: ../output/test_results/#{result_path}.htm"
end

folder_path = File.join(File.absolute_path(__FILE__).split("testing")[0],"output")
#puts Dir.getwd.split("test")[0],folder_path
# if File.exist? folder_path
  # FileUtils.remove_dir folder_path,true
# end
Dir.mkdir folder_path unless File.exist?(folder_path)
10.times do |i|
  begin
    if File.exist? folder_path
      path = File.join(folder_path,"screenshots")
      Dir.mkdir path if not File.exist? path
      path = File.join(folder_path,"test_results")
      Dir.mkdir path if not File.exist? path
      break
    end
    sleep 1
    Common.logger_error "Create folder failed in 10 seconds with #{folder_path}" if i>=9
  rescue =>e
  end
end

#init the parameters used for marquee
$result="Passed"
$errormessage=""
$screenshot=""
$error_log=""

#load all the common functions
# Dir[File.dirname(__FILE__) + '/../common/*.rb'].each {|file| require file if file!="./"<<__FILE__}
Dir[File.dirname(__FILE__) + '/../common/*/**/*.rb'].each {|file| require file if file!="./"<<__FILE__}

#load all the libraries under ../library
#Dir.glob("#{File.dirname(__FILE__)}/../library/*/*.rb").each{|f| require f}
Dir.glob("#{File.dirname(__FILE__)}/../library/*/**/*.rb").each{|f| require f}

#load all the libraries under ../workflow
#Dir.glob("#{File.dirname(__FILE__)}/../workflow/*/*.rb").each{|f| require f}
Dir.glob("#{File.dirname(__FILE__)}/../workflow/*/**/*.rb").each{|f| require f}

#get the paramaters from config.yml for each test plan into $parameters
$parameters=YAML.load(File.open("#{File.dirname(__FILE__)}/#{script_path}/config.yml"))

puts "begin running with the configuration..."
puts "environment: #{$env}"
puts "marquee username: #{$username}"
#puts "marquee url: #{$url_string}"
puts "plan name: #{$plan_name}"

describe $plan_name  do
  before(:all){
    RSpec.configure {|c| c.fail_fast = true} if options[:debug]
  }
  after(:all){    
    MARQUEE::update_script_state $round_id,$plan_name,"End","1.0.0.1"      
  }
  before(:each){ $errormessage= "" }
  after(:each) do |example| 
    example.result!
  end
  Dir[File.dirname(__FILE__) + "/#{script_path}/*.rb"].each {|file| require file}
  $parameters['actions'].split(',').each {|m| send m.strip.to_sym}
end

#end date
puts("==============End to testing #{script_path} at #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
