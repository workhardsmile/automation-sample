require 'rubygems'
require 'jira-ruby'

options = {
  :username     => 'gang.wu@istuary.com',
  :password     => '!@#2145980w',
  :site         => 'https://istuary.atlassian.net/',
  :context_path => '',
  :auth_type    => :basic
}

client = JIRA::Client.new(options)

project = client.Project.find('IronHide')

project.issues.each do |issue|
  puts "#{issue.id} - #{issue.summary}"
end