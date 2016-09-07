require_relative 'model'
require_relative '../../common/utilities/common.rb'

$testplus_config = YAML::load(File.open("#{File.dirname(__FILE__)}/config.yml"))
db_config = YAML::load(File.open("#{File.dirname(__FILE__)}/../../data/database.yml"))
Common.logger_info "Connecting to db_config['TESTPLUS']['mysql']."

ActiveRecord::Base.establish_connection db_config["TESTPLUS"]["mysql"]
ActiveRecord::Base.default_timezone = :utc
