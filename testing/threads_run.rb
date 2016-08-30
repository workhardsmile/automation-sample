#!/usr/bin/env ruby
require 'yaml'
require 'rspec'
require 'thread'
require "optparse"
require "pathname"

#Pathname.new(File.dirname(__FILE__)).realpath
#$root_path = Pathname.new(__FILE__).realpath.to_s.split("test")[0]
#set up the environment for automation tasks
#hash to hold all options
options = Hash.new
#handle options and arguments
optparse = OptionParser.new do |opts|
  #set the banner
  opts.banner = "Usage: ruby threads_run.rb -d <derctory_path> [options]"
  
  #define module path option
  options[:module_directory] = nil
  opts.on('-d', '--module_directory <string>','Module derctory path (required)', 'ex -d "camps/bvt/module-1", "endurance/regression/module-2"') do |module_directory|
    options[:module_directory] = File.join(File.dirname(__FILE__), module_directory)
  end
  
  #define scripts path option
  options[:directory_scripts] = nil
  opts.on('-s', '--directory_scripts <string>','Directory scripts path (required)', 'ex -d "camps/bvt/module-1", "endurance/regression/module-2"') do |directory_scripts|
    options[:directory_scripts] = directory_scripts.split(',').map {|script| File.join(File.dirname(__FILE__), script.strip)}
  end

  #define threads_number option
  options[:threads_number] = 5
  opts.on('-n', '--threads_number <string>',
  'Thread unmber of runner (optinal)', 'ex - "5", "10", "20"',"Set to 5 by default ") do |threads_number|
    options[:threads_number] = threads_number.to_i
    options[:threads_number] = 5 if options[:threads_number] < 0 or options[:threads_number] > 9999
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
  
  #define environment option
  options[:performance] = false
  opts.on('-pf', '--environment <string>', ["QA","REG", "PROD"],
  'Name of the test environment (optinal)','ex - "QA","REG", "PROD"','Set to QA by default') do|environment|
    options[:environment] = environment
  end
  
  options[:performance] = false
  opts.on('-pf','--performance','Start interface testing as server performance testing') do
    options[:performance] = true
  end
  
  #define round option
  options[:round] = '1234'
  opts.on('-r', '--round <string>',
  'ID of the test round (optinal)', 'ex - "9999", "8888", "7777"',"Used by Marquee client only, set to 1234 by default ") do|round|
    options[:round] = round
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
  mandatory = [:module_directory,:directory_scripts]
  missing = mandatory.select{ |param| !options[param].nil? }
  if missing.empty?
    puts("MISSING OPTIONS: #{missing.join(' or ')}")
    puts(optparse)
    exit(1)
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument, OptionParser::InvalidArgument
  puts($!.to_s)
  puts(optparse)
  exit(1)
end

if options[:directory_scripts].nil?
  options[:directory_scripts] = Array.new
  if File.directory?(options[:module_directory])
    Dir.foreach(options[:module_directory]) do |file_path|
      puts file_path
      if file_path != "." and file_path != ".."        
        script_path = File.join(options[:module_directory], file_path)
        puts script_path
        if File.directory?(script_path) && File.exist?(File.join(script_path,'config.yml'))
          options[:directory_scripts] = options[:directory_scripts] << script_path
        else
          puts("#{file_path} is not one valid test script without config.yml!")
        end
      end
    end
  else
  #Common.logger_error("#{options[:module_directory]} is not exist!")
    puts "#{options[:module_directory]} is not exist or not one folder!"
  end
end
$queue = Queue.new
options[:directory_scripts].each do |script| 
  $queue.push("ruby run.rb -s #{script} -u #{options[:username]} -p #{options[:password]} -e #{options[:environment]} -r #{options[:round]}")
end

mutex=Mutex.new
count = options[:threads_number] - $queue.length if options[:threads_number] > $queue.length
#threads number
threads = []
options[:threads_number].times.each do |i|
  threads<<Thread.new do
    until $queue.empty?
      command = $queue.pop  
      if options[:performance]    
        mutex.lock
          $queue.push(command) if count > 0
          count -= 1
        mutex.unlock
      end
      puts `#{command}` 
    end
  end
end
threads.each{|t| t.join}
