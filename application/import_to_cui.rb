require "net/http"
require "uri"
require 'rexml/document'
require "find"
require "yaml"

include REXML
class ImportAutoScript
  attr_accessor :url, :config
  def initialize
    @config = YAML.load(File.open("#{File.dirname(__FILE__)}/project_config.yml"))
    @url ="http://marquee.dev.activenetwork.com/import_data/import_script_without_test_plan"
  end

  def create_xml (strScriptName,strPlanName,strStatus,strComment,strOwner,intTime,strProject,strDriver,strTags,arrayCaseID)
    doc = REXML::Document.new
    data = doc.add_element("data")
    auto_script = data.add_element("automation_script")
    script_name = auto_script.add_element("script_name")
    script_name.add_text strScriptName
    tp_name = auto_script.add_element("plan_name")
    tp_name.add_text strPlanName
    status = auto_script.add_element("status")
    status.add_text strStatus
    comment = auto_script.add_element('comment')
    comment.add_text strComment
    owner = auto_script.add_element("owner")
    owner.add_text strOwner
    timeout = auto_script.add_element("timeout")
    timeout.add_text intTime.to_s
    project = auto_script.add_element("project")
    project.add_text strProject
    driver = auto_script.add_element("auto_driver")
    driver.add_text strDriver
    tags = auto_script.add_element("tags")
    tags.add_text strTags
    auto_cases = data.add_element("automation_cases")
    arrayCaseID.each do |tc|
      case_id = auto_cases.add_element("case_id")
      case_id.add_text tc
    end
    doc.to_s
  end

  def post url_string, xml_string
    uri = URI.parse url_string
    request = Net::HTTP::Post.new uri.path
    request.body = xml_string
    request.content_type = 'text/xml'
    response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request request }
  end

  def parese_code(strProject,strDriver,strPath,strPrefix,strScriptPrefix)
    Dir.glob("#{File.dirname(__FILE__)}/#{strPath}/#{strScriptPrefix}*").each do |folder|
      if File.directory?(folder)
        if File.exist? "#{folder}/config.yml"
          puts ">>>>>> parse for script -- #{folder}"
          as = Hash.new
          as["script_name"] = File.basename(folder).gsub(".rb","")
          as["case_info"] = Array.new
          # get script information from the config.yml
          config = YAML.load(File.open("#{folder}/config.yml"))
          if config
            as["plan_name"]= config["plan_name"]
            as["timeout_limit"]= config["timeout"]
            as["status"]= config["status"]
            as["owner"]= config["owner"]
            as["status"]= config["status"].downcase.match(/complete[d]*|finish[ed]*/) ? 'completed' : config['status']
            as['comment'] = config['comment']
            as['tags']= config['keywords']
            # get the script name and case ids from script files

            Dir.glob("#{folder}/*.rb").each do |file_path|
              File.open(file_path, "r") do |file|
                file.each_line  do |line|
                  if /^\s*it ".*do/.match(line)
                    temp = line.split('"')[1].split("_")
                    if temp[0] and temp[1]
                      temp[0].split("##").each do |case_id|
                        as["case_info"].push "#{case_id}###{temp[1]}" if case_id.include? strPrefix
                      end
                    end
                  end
                end
              end
            end
            if as["case_info"].size > 0
              puts as
              xml = create_xml(as['script_name'],as["status"],as["comment"],as["owner"],as["timeout_limit"],strProject,strDriver,as["tags"],as["case_info"])
              post @url,xml.to_s
            end
          else
            puts "#{as['script_name']} has wrong config.yml"
          end
        end
      end
    end
  end
end

import_data =  ImportAutoScript.new
config = import_data.config
project = ARGV[0].nil? ? false : ARGV[0]
#project = "endurance_cui"
if project
  unless config["#{project}"].nil?
    config["#{project}"].each do |c|
      import_data.parese_code c['marquee_name'], c['config_name'], c['path'], c['id_prefix'], c['cui_prefix']
    end
  else
    puts "the project <#{project}> you entered is wrong"
  end
else
  puts "you must specify the project"
end
