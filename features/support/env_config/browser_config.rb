require 'selenium-webdriver'

module BrowserConfig
  def self.configure_browser(browser, options)
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.open_timeout = options[:wait_time]
    client.read_timeout = options[:wait_time]

    Capybara::Selenium::Driver.new(
      options[:app],
      browser: browser,
      options: options[:driver_options],
      http_client: client
    )
  end

  def self.register_drivers(wait_time)
    register_chrome(wait_time)
    register_chrome_mweb(wait_time)
    register_firefox(wait_time)
    register_firefox_mweb(wait_time)
    register_safari(wait_time)
    register_safari_mweb(wait_time)
  end

  def self.register_chrome(wait_time)
    Capybara.register_driver :chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      if ENV['HEADLESS'].downcase == 'yes'
        options.add_argument('--headless=new')
      end
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--disable-notifications')
      options.add_argument('--window-size=1366,1000')
      if ENV["PRIVATE"].downcase == 'yes'
        options.add_argument('--headless=new')
      end
      # handle basic auth
      options.add_argument('--disable-blink-features=BlockCredentialedSubresources')
      options.add_argument('--disable-blink-features=AutomationControlled')
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = wait_time
      client.read_timeout = wait_time

      configure_browser(:chrome, app: app, driver_options: options, wait_time: wait_time)
    end
  end

  def self.register_chrome_mweb(wait_time)
    Capybara.register_driver :chrome_mweb do |app|
      options = Selenium::WebDriver::chrome::Options.new
      if ENV['HEADLESS'].downcase == 'yes'
        options.add_argument('--headless')
      end
      options.add_argument("-user-agent='#{ENV['MWEB_USER_AGENT']}'")
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--disable-notifications')
      options.add_argument('start-maximized')
      if ENV["PRIVATE"].downcase == 'yes'
        options.add_argument('--headless')
      end
      # handle basic auth
      options.add_argument('--disable-blink-features=BlockCredentialedSubresources')
      options.add_argument('--disable-blink-features=AutomationControlled')
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = wait_time
      client.read_timeout = wait_time

      configure_browser(:chrome, app: app, driver_options: options, wait_time: wait_time)
    end
  end

  def self.register_chrome(wait_time)
    Capybara.register_driver :chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
  
      # Start maximized
      options.add_argument('--start-maximized')
  
      # Headless support
      if ENV['HEADLESS']&.downcase == 'yes'
        options.add_argument('--headless')
        options.add_argument('--disable-gpu')
        options.add_argument('--window-size=1366,1000') # required for headless
      end
  
      # Incognito / private browsing
      if ENV['PRIVATE']&.downcase == 'yes'
        options.add_argument('--incognito')
      end
  
      # Disable notifications and automation flags
      options.add_argument('--disable-notifications')
      options.add_argument('--disable-infobars')
      options.add_argument('--disable-blink-features=AutomationControlled')
  
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = wait_time
      client.read_timeout = wait_time
  
      configure_browser(:chrome, app: app, driver_options: options, wait_time: wait_time)
    end
  end

  def self.register_firefox(wait_time)
    Capybara.register_driver :firefox do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      options = Selenium::WebDriver::Firefox::Options.new
  
      # Headless mode
    if ENV['HEADLESS']&.downcase == 'yes'
        options.add_argument('--headless')
        options.add_argument('--width=1366')
        options.add_argument('--height=1000')
      else
        options.add_argument('--start-maximized') # Only works in GUI mode
      end
  
      # Firefox-specific preferences to reduce automation detection and notifications
      options.add_preference 'dom.webdriver.enabled', false
      options.add_preference 'dom.webnotifications.enabled', false
      options.add_preference 'dom.push.enabled', false
  
      # Private browsing
      if ENV['PRIVATE']&.downcase == 'yes'
        options.add_argument('-private')
      end
  
      # Assign profile
      options.profile = profile
  
      # HTTP client config
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = wait_time
      client.read_timeout = wait_time
  
      configure_browser(:firefox, app: app, driver_options: options, wait_time: wait_time)
    end
  end
  
  

  def self.register_firefox_mweb(wait_time)
    Capybara.register_driver :firefox_mweb do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      options = Selenium::WebDriver::Firefox::Options.new
      if ENV['HEADLESS'].downcase == 'yes'
        options.add_argument('--headless')
      end
      profile['general.useragent.override'] = ENV['MWEB_USER_AGENT']
      options.add_preference 'dom.webdriver.enabled', false
      options.add_preference 'dom.webnotifications.enabled', false
      options.add_preference 'dom.push.enabled', false
      options.add_argument('--width=411')
      options.add_argument('--height=823')
      if ENV["PRIVATE"].downcase == 'yes'
        options.add_argument('-private')
      end
      options.profile = profile
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = wait_time
      client.read_timeout = wait_time

      configure_browser(:firefox, app: app, driver_options: options, wait_time: wait_time)
    end
  end

  def self.register_safari(wait_time)
    Capybara.register_driver :safari do |app|
      options = Selenium::WebDriver::Safari::Options.new
      client = Selenium::WebDriver::Remote::Http::Default.new

      client.open_timeout = wait_time
      client.read_timeout = wait_time

      configure_browser(:safari, app: app, driver_options: options, wait_time: wait_time)
    end
  end

  # Still looking for fixing the safari_nweb driver
  def self.register_safari_mweb(wait_time)
    Capybara.register_driver :safari_mweb do |app|
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = wait_time
      client.read_timeout = wait_time

      caps = Selenium::WebDriver::Safari::Options.safari(
        'safari.options' => {
          'technologyPreview' => false,
          'cleanSession' => true,
          'automaticInspection' => false,
          'automaticProfiling' => true
        },
        'goog:chromeOptions' => {
          'mobileEmulation' => {
            'deviceName' => "iPhone 13",
            'userAgent' => "Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19"
          }
        }
      )

      configure_browser(:safari, app: app, driver_options: options, wait_time: wait_time)
    end
  end
end
