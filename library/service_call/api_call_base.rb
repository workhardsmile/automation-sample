# encoding: UTF-8
require 'yaml'
require "uri"
require "rest-client"
require "json"
require 'digest/md5'
require 'addressable/uri'

class ApiCallBase
  SERVICE_API_URL=YAML.load(File.open("#{File.dirname(__FILE__)}/../../data/webserver_url.yml"))
  SKEY='65a231f31de9330780942b109692e5a1e2a779b51781349aaea2dae44958a1d644a803af21bbb318695e58b758f94e7aa3a5450a3f7092f6e05ea172d9b95043'
  AVERSION = '1.1.0'
  STYPE = 'Andriod'
  SYSINFO = '5.1'
  DEVICE = 'm2 note'
  attr_reader :headers, :user, :mobile
  def self.get_user_token(mobile="15800000002",password="123456")
    host = SERVICE_API_URL[$env]["Host"]
    data = {"mobile" => "#{mobile}","password" => "#{password}"}

    response = RestClient.post "#{SERVICE_API_URL[$env]["Host"]}/api/mobile/v1/users/sign_in", data
    user_info = JSON.parse(response) rescue response
    return  user_info, response.headers[:access_token]
  end
  
  def self.get_admin_user_token(user_name="smart",password="123456")
    host = SERVICE_API_URL[$env]["Host"]
    data = {"user_name" => "#{user_name}","password" => "#{password}"}

    response = RestClient.post "#{SERVICE_API_URL[$env]["Host"]}/api/admin/users/sign_in", data
    user_info = JSON.parse(response) rescue response
    return  user_info, response.headers[:access_token]
  end
  
  def self.url_query_string(hash={},is_url=false)
    if hash.instance_of? String
      URI.encode hash
    elsif is_url
      uri = Addressable::URI.new
      uri.query_values = hash
      uri.query
    else      
      query_str = ""
      hash.reject{ |key,value| query_str="#{query_str}&#{key}=#{value}" }
      query_str[1,query_str.length-1]
    end
  end

  def initialize
    @headers = {#:accept => "application/json, text/javascript, */*; q=0.01", 
      "Connection" => "Keep-Alive",
      "Content-Type" => "application/json; charset=utf-8", 
      "User-Agent" => "Dalvik/2.1.0 (Linux; U; Android 6.0; MI 5 MIUI/V7.5.6.0.MAACNDE)",
      "Device-Info"=>"appVersion=#{AVERSION};systemType=#{STYPE};systemInfo=#{SYSINFO};deviceModel=#{DEVICE}"}
    @user = nil
    @token = nil
  end

  def set_user_token(user_id="15800000002",password="123456",is_admin=false)
    @mobile = user_id
    if is_admin
      @user,@token = ApiCallBase.get_admin_user_token(user_id,password)
    else      
      @user,@token = ApiCallBase.get_user_token(user_id,password)
    end    
    @headers =  @headers.merge({"Authorization" => "Token token=#{@token}"})
  end
   
  def get_md5_sign_str(method,request_api,request_body)
    query_str = "&#{ApiCallBase.url_query_string(Hash[request_body.sort])}" unless (request_body.nil? || request_body == {})
    #Hash[hash1.sort_by{|key, val|key}]
    md5_sign_str = "#{@token}".strip == "" ? "#{SKEY}&#{method}&#{request_api}#{query_str}" : "#{SKEY}&#{@token}&#{method}&#{request_api}#{query_str}"
    #puts md5_sign_str
    md5_sign = Digest::MD5.hexdigest(md5_sign_str).downcase
  end
  private :get_md5_sign_str
 
  # @method => put request_body to request_api with header_parameters (header)
  # response string or nil
  def put_by_api(request_api,request_body,header_parameters={})   
    @headers = @headers.merge({ "Sign" => get_md5_sign_str("#{__method__}".split("_")[0],request_api,request_body)})
    host = SERVICE_API_URL[$env]["Host"]
    request_url ="#{host}#{request_api}"

    Common.logger_info "header: #{@headers}"
    Common.logger_info "put request by #{request_url}."
    Common.logger_info "request data -->> #{request_body}."

    begin
      result = RestClient.put request_url, request_body, @headers.merge(header_parameters)
      Common.logger_info "put by #{request_api} successfully!"
      JSON.parse(result) rescue result
    rescue => e
      Common.logger_error "error in put from url: -- #{request_url} \n #{e.message}"
      result = nil
    end
  end

  # @method => post request_body to request_api with header_parameters (header)
  # response string or nil
  def post_by_api(request_api,request_body,header_parameters={})
    @headers = @headers.merge({ "Sign" => get_md5_sign_str("#{__method__}".split("_")[0],request_api,request_body)})
    host = SERVICE_API_URL[$env]["Host"]
    request_url ="#{host}#{request_api}"

    Common.logger_info "header: #{@headers}"
    Common.logger_info "post request by #{request_url}."
    Common.logger_info "request data -->> #{request_body}."

    begin
      result = RestClient.post request_url, request_body, @headers.merge(header_parameters)
      Common.logger_info "post by #{request_api} successfully!"
      JSON.parse(result) rescue result
    rescue => e
      Common.logger_error "error in post from url: -- #{request_url} \n #{e.message}"
      result = nil
    end
  end

  # @method => get from request_api with header_parameters (header)
  # response string or nil
  def get_by_api(request_api,request_body={}, header_parameters={})
    query_str = "?#{ApiCallBase.url_query_string(request_body,true)}" unless ("#{request_body}"=="" || request_body=={})
    @headers = @headers.merge({ "Sign" => get_md5_sign_str("#{__method__}".split("_")[0],request_api,request_body)})
    host = SERVICE_API_URL[$env]["Host"]
    request_url ="#{host}#{request_api}#{query_str}"
    begin
      Common.logger_info "header: #{@headers}"
      Common.logger_info "get request by #{request_url}."
      Common.logger_info "request data -->> #{request_body}."
      result = RestClient.get request_url, @headers.merge(header_parameters)
      Common.logger_info "get by #{request_api} successfully!"
      JSON.parse(result) rescue result
    rescue => e
      Common.logger_error "error in get response from url: -- #{request_url} \n #{e.message}"
      result = nil
    end
  end

  # @method => delete from request_api with header_parameters (header)
  # response string or nil
  def delete_by_api(request_api,request_body={}, header_parameters={})
    query_str = "?#{ApiCallBase.url_query_string(request_body,true)}" unless ("#{request_body}"=="" || request_body=={})
    @headers = @headers.merge({ "Sign" => get_md5_sign_str("#{__method__}".split("_")[0],request_api,request_body)})
    host = SERVICE_API_URL[$env]["Host"]
    request_url ="#{host}#{request_api}#{query_str}"
    begin
      Common.logger_info "header: #{@headers}"
      Common.logger_info "delete request by #{request_url}."
      Common.logger_info "request data -->> #{request_body}."
      result = RestClient.delete request_url, @headers.merge(header_parameters)
      Common.logger_info "delete by #{request_api} successfully!"
      JSON.parse(result) rescue result
    rescue => e
      Common.logger_error "error in delete from url: -- #{request_url} \n #{e.message}"
      result = nil
    end
  end

# private :get_cookie
# protected :post_by_api,:put_by_api,:get_by_api,:delete_by_api
end

