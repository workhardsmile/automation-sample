require "net/http"
require "uri"
require "rexml/document"

include REXML
SCREEN_SHORT_FOLDER = Dir.exist?("c:/marquee/screen_shots") ? "c:/marquee/screen_shots" : "#{File.dirname(__FILE__)}/../../output/screenshots"

module MARQUEE
  def self.post url_string, xml_string
    uri = URI.parse url_string
    request = Net::HTTP::Post.new uri.path
    request.body = xml_string
    request.content_type = 'text/xml'
    response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request request }
  end

  def self.update_script_state(id,name,tp_state,service_info)
    if id != "DEBUG"
      tp_description = tp_state
      if tp_state.downcase == 'end'
        tp_state = 'done'
      else
        tp_state = 'failed'
      end
      doc = REXML::Document.new
      protocol = doc.add_element("protocol")
      what = protocol.add_element("what")
      what.add_text "Script"
      round_id = protocol.add_element("round_id")
      round_id.add_text id.to_s
      data = protocol.add_element("data")
      script_name = data.add_element("script_name")
      script_name.add_text name.to_s
      state = data.add_element("state")
      state.add_text tp_state
      desc = data.add_element('description')
      desc.add_text tp_description
      if service_info != nil
        service = data.add_element('service')
      service.add_text service_info
      end
      if ENV['ResultPath'] != nil
        file_name = "#{ENV['ResultPath']}/sr_#{id}_#{Time.now.strftime("%Y%m%d%H%M%S")}_#{name}.xml"
        save_file_to_path(file_name,doc.to_s)
        Common.logger_info "write script state for [#{name}] to >> #{file_name}"
      end
    end
  end

  def self.update_case_result(id,name,case_number_string,tc_result,tc_error,tc_screen_shot,tc_error_log)
    if id != "DEBUG"
      case_number_string.split('||').each do |case_number|
        doc = REXML::Document.new
        protocol = doc.add_element("protocol")
        what = protocol.add_element("what")
        what.add_text "Case"
        round_id = protocol.add_element("round_id")
        round_id.add_text id
        data = protocol.add_element("data")
        script_name = data.add_element("script_name")
        script_name.add_text name
        case_id = data.add_element("case_id")
        case_id.add_text case_number
        test_result = data.add_element("result")
        test_result.add_text tc_result
        error = data.add_element("error")
        error.add_text tc_error.to_s
        screen_shot = data.add_element("screen_shot")
        screen_shot.add_text tc_screen_shot
        server_log = data.add_element("server_log")
        server_log.add_text tc_error_log.to_s
        #post $url_string, doc.to_s
        if ENV['ResultPath'] != nil
          file_name = "#{ENV['ResultPath']}/cr_#{id}_#{Time.now.strftime("%Y%m%d%H%M%S")}_#{case_number.gsub(/[^a-zA-Z 0-9]/, '')}.xml"
          save_file_to_path(file_name,doc.to_s)
          Common.logger_info "[#{case_number}] - [#{tc_result}], write result to >> #{file_name}"
          if tc_result != "Passed"
            Common.logger_info '##################################################################'
            Common.logger_info tc_error
            Common.logger_info '##################################################################'
          end
        end
      end
    end
  end

  def self.save_file_to_path(file_path,xml_string)
    aFile = File.new(file_path, "w")
    aFile.write(xml_string)
    aFile.close
  end

  def self.get_service_info(service_name,environment)
    
    if $round_id != "DEBUG"
      case environment.upcase
      when "INT"
        env = "LV-INT"
      when "QA"
        env = "LV-QA"
      when "REG"
        env = "LV-REG"
      when "STG"
        env = "LV-STAGE"
      when "PROD"
        env = "LV-PROD"
      when "PINT"
        env = "LV-PINT"
      else
      Common.logger_info "failed to get service info, #{environment} is not supported"
      return
      end
      begin
      @result =""
      data = "env1=#{env}&env2=#{env}"
      my_connection = Net::HTTP.new('arm-01w.dev.activenetwork.com',8080)
      response = my_connection.post('/ActiveDeploy/CompareHandle', data)
      temp = response.body.split("</a><p>")
      service_name.split('##').each do |s|
        temp.each do |t|
          if (/.*#{s}.*/).match t
            @result += "#{s}"+'#'+"#{t.split("to").last.gsub(" ","")}"+'|'
          end
        end
      end
      @result.chop
      rescue Exception => e
        Common.logger_info "#{e}"
        "failed to get service info, check log for more info"
      end
      
    end
  end
end
