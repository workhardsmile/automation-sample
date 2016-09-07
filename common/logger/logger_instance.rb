require 'logger'
require 'fileutils'

class LoggerS
  path = File.join(File.dirname(__FILE__),"../..","output","log")
  
  # New Line, creates subdirectories if needed
  FileUtils.mkdir_p path if not File.exist? path


  path = File.join(File.dirname(__FILE__),"../..","output","log","automation.log")
  @@instance = Logger.new path

  def self.instance
    return @@instance
  end

  private_class_method :new
end

$logger = LoggerS.instance

