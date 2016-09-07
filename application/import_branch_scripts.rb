require "net/http"
require "uri"
require 'rexml/document'
require "find"
require "yaml"
require 'json'
require 'rest_client'

include REXML
class ImportAutoScript
  attr_accessor :url, :config
  def initialize
    @config = YAML.load(File.open("#{File.dirname(__FILE__)}/project_config.yml"))
    @url = "http://marquee.dev.activenetwork.com/project_branch_scripts/import"
    # @url = "http://10.109.0.112:3000/project_branch_scripts/import"
  end


  def post request_url, request_body
    result = RestClient.post request_url, request_body ,{:content_type => :json}
    puts "result:#{result}"
  end

  def import_scripts(strProject,strDriver,strPath,strPrefix)
    scripts = []
    Dir.glob("#{File.dirname(__FILE__)}/#{strPath}/*").each do |folder|
      if File.directory?(folder)
        if File.exist? "#{folder}/config.yml"
          puts ">>>>>> parse for script -- #{folder}"
          scripts << File.basename(folder).gsub(".rb","")
        end
      end
    end
    begin
      data = {
        "project_name" =>"Platform-Commerce",
        "branch_name" => "qa_test",
        "scripts" => scripts
        }
      puts "data:#{data}"  
      post @url,data        
    rescue => e
      puts "#####\n####EXCEPTION: #{e}"
    end
  end
end

import_data =  ImportAutoScript.new
config = import_data.config
project = ARGV[0].nil? ? false : ARGV[0]
#project = "commerce"
if project
  unless config["#{project}"].nil?
    config["#{project}"].each do |c|
      import_data.import_scripts c['marquee_name'], c['config_name'], c['path'], c['id_prefix']
    end
  else
    puts "the project <#{project}> you entered is wrong"
  end
else
  puts "you must specify the project"
end






