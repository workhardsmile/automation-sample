require 'selenium-webdriver'

module  WebDriver
  class << self

    $DOWNLOAD_PATH =File.absolute_path("#{File.dirname(__FILE__)}/../../output/downloads").gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
    def restart_browser
      $driver.quit unless $driver.nil?
      start_browser
    end

    def start_browser
      # accept browser types "ie", "firefox", "chrome"
      if $browser == 'firefox'
        profile = Selenium::WebDriver::Firefox::Profile.new
        Dir.mkdir $DOWNLOAD_PATH unless Dir.exist?($DOWNLOAD_PATH)
        profile['browser.download.dir'] = $DOWNLOAD_PATH
        profile['browser.download.folderList'] = 2
        profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf,text/csv,application/zip"
        $driver = Selenium::WebDriver.for :firefox, :profile=>profile
      else
        if $browser == 'chrome'
          Dir.mkdir $DOWNLOAD_PATH unless Dir.exist?($DOWNLOAD_PATH)
          prefs = {
            :download => {
              :prompt_for_download => false,
              :default_directory => $DOWNLOAD_PATH
            },
          }
          prefs['profile.default_content_settings.multiple-automatic-downloads'] = 1
          switches = %w[--test-type --ignore-certificate-errors --disable-popup-blocking --disable-translate]
          $driver = Selenium::WebDriver.for :chrome, :prefs => prefs, :switches => switches
        else
          $driver = Selenium::WebDriver.for $browser.to_sym
        end
      end
      $driver.get "about:blank"
      max_width, max_height = $driver.execute_script("return [window.screen.availWidth, window.screen.availHeight];")
      $driver.manage.window.resize_to(max_width, max_height)
      $wait = Selenium::WebDriver::Wait.new(:timeout=>30)
    end

    # note: before called this api need to add gem 'webdriver-user-agent', '7.1' to your local gem file first and then require 'webdriver-user-agent' in the main.rb
    # this function only support chrome or firefox
    # device-> :iphone,:ipad_seven,:ipad,:android_phone,:android_tablet
    # layout-> :portrait,:landscape
    def start_mobile_browser(device=:iphone,layout=:portrait)
      devices_config = YAML.load_file("#{File.dirname(__FILE__)}/data/user_agent_devices.yaml")
      width = devices_config[device][layout][:width]
      height = devices_config[device][layout][:height]
      user_agent_string = devices_config[device][:user_agent]
      #simulate iphone & ipad device with Safari on mac machine
      if $OS == :macosx and (device == :iphone or device == :ipad)
        current_user_agent = `defaults read com.apple.Safari CustomUserAgent`
        unless current_user_agent.include? user_agent_string
          system %Q(defaults write com.apple.Safari CustomUserAgent '"#{user_agent_string}"')
        end
        $driver = Selenium::WebDriver.for :safari
      else
        # #simulate chrome
        Dir.mkdir $DOWNLOAD_PATH unless Dir.exist?($DOWNLOAD_PATH)
        prefs = {
          :download => {
            :prompt_for_download => false,
            :default_directory => $DOWNLOAD_PATH,
			:timeout => 60
          },
        }
        switches = %w[--test-type --ignore-certificate-errors --disable-popup-blocking --disable-translate]
        switches << "--user-agent=#{user_agent_string}"
        $driver = Selenium::WebDriver.for :chrome, :prefs => prefs,:switches => switches
        $driver.execute_script("window.open(#{$driver.current_url.to_json},'_blank','innerHeight=#{height},innerWidth=#{width}');")
        $driver.close
        $driver.switch_to.window $driver.window_handles.first
      end
      $driver.manage.window.resize_to(width, height)
    end
    
    def restart_non_blank_browser(language=nil)
      restart_browser if $driver == nil || $driver.current_url.include?("http")
    end

    # note: before called this api need to add gem 'webdriver-user-agent', '7.1' to your local gem file first and then require 'webdriver-user-agent' in the main.rb
    def restart_mobile_browser(device=:iphone,layout=:portrait)
      if $driver
        $driver.quit rescue false
        $driver = nil
      end
      start_mobile_browser(device,layout)
    end

    def alert_accept
      alert = $driver.switch_to.alert
      alert.accept
    end

    def alert_dismiss
      alert = $driver.switch_to.alert
      alert.dismiss
    end

    def get_alert_content
      alert = $driver.switch_to.alert
      alert.text
    end

    def switch_browser_by_index (index)
      browsers = $driver.window_handles
      $driver.switch_to.window(browsers[index])
    end

    def switch_to_frame_by_path(path)
      switch_to_default_frame
      path.split('/').each do |p|
        switch_to_frame_by_name p
      end
    end

    def switch_to_frame_by_name(name)
      puts "<-- switch to frame --> #{name}"
      $driver.switch_to.frame($driver.find_element(:name,"#{name}"))
    end

    def switch_to_frame_by_class(class_name)
      puts "<-- switch to frame --> #{class_name}"
      $driver.switch_to.frame($driver.find_element(:class,"#{class_name}"))
    end

    def switch_to_frame_by_id(id)
      puts "<-- switch to frame --> #{id}"
      $driver.switch_to.frame($driver.find_element(:id,"#{id}"))
    end

    def switch_to_frame_by_xpath(xpath)
      puts "<-- switch to frame by xpath --> #{xpath}"
      $driver.switch_to.frame($driver.find_element(:xpath,"#{xpath}"))
    end

    def switch_to_default_frame
      $driver.switch_to.default_content
    end

    def refresh_page
      $driver.navigate.refresh
    end

    def navigate_to_url(url)
      begin
        Common.logger_step "Execute - Navigate to URL #{url} - success."
        $driver.get url
      rescue Timeout::Error
        Common.logger_info "Execute - Navigate to URL #{url} - warnning. get Timeout::Error "
      end
    end

    def get_current_url ()
      $driver.current_url
    end

    def close_browser()
      $driver.quit
    end

    def close_current_window
      $driver.close
    end

    def back
      $driver.navigate.back
    end

    def forward
      $driver.navigate.forward
    end

  end
end
