require 'yaml'
require 'redis'

#require_relative '../../common/utilities/common.rb'
class DatabaseRedis
  def self.get_redis(env)
    @envHash = Hash.new
    #get the database config from ../../data/database.yml by $env
    db_config = YAML.load(File.open("#{File.dirname(__FILE__)}/../../data/database.yml"))
    @envHash[:host]=db_config[env]['redis']['host']
    @envHash[:port]=db_config[env]['redis']['port']
    @redis = Redis.new(@envHash)
  end

  def initialize(env)
    @redis = self.class.get_redis(env)
  end

  #删除注册、重置、修改密码相关redis
  def reset_sms_by_mobile(mobile)
    @redis.del("sms:register:success_count:#{mobile}")
    @redis.del("sms:forget_password:success_count:#{mobile}")
    @redis.del("sms:update_password:success_count:#{mobile}")
    @redis.del("sms:register:error_count:#{mobile}")
    @redis.del("sms:forget_password:error_count:#{mobile}")
    @redis.del("sms:update_password:error_count:#{mobile}")
  end

  #注册验证码
  def get_register_code_by_mobile(mobile)
    code = @redis.get("sms:register:#{mobile}")
    return code
  end

  #注册验证码有效期
  def get_register_codetime_by_mobile(mobile)
    time = @redis.ttl("sms:register:#{mobile}")
    return time
  end

  #注册成功接收短信次数
  def get_register_success_count_by_mobile(mobile)
    count = @redis.get("sms:register:success_count:#{mobile}")
    return count
  end

  #注册失败次数
  def get_register_error_count_by_mobile(mobile)
    count = @redis.get("sms:register:error_count:#{mobile}")
    return count
  end  

  #忘记密码验证码
  def get_forget_code_by_mobile(mobile)
    code = @redis.get("sms:forget_password:#{mobile}")
    return code
  end

  #忘记密码验证码有效期
  def get_forget_codetime_by_mobile(mobile)
    time = @redis.ttl("sms:forget_password:#{mobile}")
    return time
  end
  
  def expire_sms_time_by_mobile(mobile,type_name='register')
    @redis.expire("sms:#{type_name}:#{mobile}",3)
  end
  
  def set_error_count_by_type_and_mobile(type,mobile,n)
    type_name = nil
    case type.to_i
    when 1
      type_name = 'register'
    when 2
      type_name = 'forget_password'
    when 3
      type_name = 'update_password'
    end
    @redis.set("sms:#{type_name}:error_count:#{mobile}",n)
  end
      
  def set_success_count_by_type_and_mobile(type,mobile,n)
    type_name = nil
    case type.to_i
    when 1
      type_name = 'register'
    when 2
      type_name = 'forget_password'
    when 3
      type_name = 'update_password'
    end
    @redis.set("sms:#{type_name}:success_count:#{mobile}",n)
  end

  #忘记密码成功接收短信次数
  def get_forget_success_count_by_mobile(mobile)
    count = @redis.get("sms:forget_password:success_count:#{mobile}")
    return count
  end

  #忘记密码失败次数
  def get_forget_error_count_by_mobile(mobile)
    count = @redis.get("sms:forget_password:error_count:#{mobile}")
    return count
  end

  #修改密码验证码
  def get_update_code_by_mobile(mobile)
    code = @redis.get("sms:update_password:#{mobile}")
    return code
  end

  #修改密码验证码有效期
  def get_update_codetime_by_mobile(mobile)
    time = @redis.ttl("sms:update_password:#{mobile}")
    return time
  end

  #修改密码成功接收短信次数
  def get_update_success_count_by_mobile(mobile)
    count = @redis.get("sms:update_password:success_count:#{mobile}")
    return count
  end

  #修改密码失败次数
  def get_update_error_count_by_mobile(mobile)
    count = @redis.get("sms:update_password:error_count:#{mobile}")
    return count
  end

  #昵称修改时间
  def get_update_username_time_by_userid(userid)
    time = @redis.ttl("user:update_username:#{userid}")
    return time
  end

  #删除昵称修改限制时间
  def del_update_username_by_userid(userid)
    @redis.del("user:update_username:#{userid}")
  end

  #昵称修改
  def get_username_status_by_userid(userid)
    status = @redis.get("user:update_username:#{userid}")
    return status
  end
end

# redis = DatabaseRedis.get_redis("QA")
# redis.set:"str1","1234567890"
# p redis.get:"str1"
