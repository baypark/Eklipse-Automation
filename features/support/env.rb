$LOAD_PATH.unshift File.expand_path('../../page_object', __FILE__)

require 'base64'
require 'capybara/cucumber'
require 'capybara/rspec'
require 'date'
require 'dotenv'
require 'httparty'
require 'json'
require 'logger'
require 'mail'
require 'net/http'
require 'net/http/post/multipart'
require 'net/imap'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'quickchart'
# require 'report_builder'
require 'rexml/document'
# require 'reportportal'
require 'selenium-webdriver'
require 'site_prism'
require 'uri'
require 'webdrivers'
require 'yaml'
# Additional configuration
require_relative 'env_config/browser_config'
require_relative 'env_config/get_config_helper'
# require_relative '../helper/other/report_helper'

Dotenv.load
Dotenv.overload(".env.#{ENV['ENV']}")

def load_browser(tags)
  browser = (ENV['BROWSER'] || 'chrome').downcase.to_sym
  Capybara.default_driver = Capybara.javascript_driver = browser
  Capybara.current_driver = browser
  puts "BROWSER ENV VAR: #{ENV['BROWSER'].inspect}"
end

BrowserConfig.register_drivers($wait_time)

Capybara.configure do |config|
  # Thread info
  puts "Target    : #{(ENV["TARGET"] || 'default').capitalize}"
  puts "Browser   : #{(ENV['BROWSER'] || 'chrome').capitalize}"
  puts "Private   : #{(ENV["PRIVATE"] || 'false').capitalize}"
  puts "Headless  : #{(ENV["HEADLESS"] || 'true').capitalize}"
  puts "DEBUG ENV KEYS:"
  puts ENV.keys.sort
  
  # set_global_params_for_reporting
  # display_banner

  # Config
  config.default_max_wait_time = ENV['MAX_WAIT_TIME'].to_i
  config.default_driver = ENV['BROWSER'].to_sym
end

# Slack.configure do |config|
#   config.token = ENV['SLACK_API_TOKEN']
#   raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
# end

# at_exit do |scenario|
#   end_time = Time.now.to_i
#   $duration = Time.at(end_time - $start_time)
#                   .utc.strftime('%H:%M:%S')
#   if ENV['IS_PARALLEL'] != 'true'
#     generate_report($json_result_cucumber, $report_path, $start_time, $tags_run)
#   end
# end

# if start_time && end_time
#   duration = (end_time || Time.now) - (start_time || Time.now)
# else
#   puts "start_time or end_time is nil"
# end

Before do
  @start_time = Time.now
end

at_exit do
  end_time = Time.now
  duration = end_time - @start_time if defined?(@start_time)
  puts "Total test run duration: #{duration} seconds" if duration
end


After do |scenario|
  $scenario_count += 1
  puts "Scenarios run so far: #{$scenario_count}"
  take_screenshot(scenario) if scenario.failed?
  Capybara.current_session.driver.quit
end

if ENV['SPEED']
  require 'selenium-webdriver'
  module ::Selenium
    module WebDriver
      module Remote
        class Bridge
          alias old_execute execute

          def execute(*args)
            sleep(0.1)
            old_execute(*args)
          end
        end
      end
    end
  end
end
