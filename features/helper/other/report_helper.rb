require 'report_builder'
require 'dotenv/load'
# require_relative '../../support/slack'

# def display_banner
#   file_path = 'config/banner.txt'
#   puts File.read(file_path)
# end

# def set_global_params_for_reporting
#   set_common_global_params
#   $json_result_cucumber = 'features/support/reports/result.json'
#   $report_path = 'features/support/reports/index'
# end

def set_common_global_params
  $browser = ENV['BROWSER'].to_sym
  $wait_time = ENV['MAX_WAIT_TIME'].to_i * 5
  $passed = 0
  $failed = 0
  $scenario_count = 0
  $scenario_name = ''
  $feature_count = 0
  $feature_name = ''
  $start_time = Time.now.to_i
end

def take_screenshot(scenario)
  scenario_name = scenario.name.gsub(/[^\w\-]/, ' ')
  time = Time.now.strftime('%Y-%m-%d %H%M')
  screenshot_path = "features/support/failed_png/#{time} - #{scenario_name}.png"
  Capybara.current_session.driver.save_screenshot(screenshot_path)
  image = open(screenshot_path, 'rb', &:read)
  encoded_image = Base64.encode64(image)
  embed(encoded_image, 'image/png;base64', 'SCREENSHOT')
end

def generate_report(json_input_path, report_path, start_time, tags)
  end_time = Time.now.to_i
  duration = Time.at(end_time - start_time).utc.strftime('%H:%M:%S')

  ReportBuilder.configure do |config|
    config.input_path = json_input_path
    config.report_path = report_path
    config.report_title = 'Test Result'
    config.additional_info = {
      Domain: 'POS JT Automation',
      Browser: ENV['BROWSER']&.capitalize,
      Environment: ENV['TARGET']&.capitalize,
      Tags: tags&.join(', '),
      "Run at": Time.now.strftime('%d-%m-%Y %H.%M'),
      Duration: duration
    }
    config.include_images = true
  end

  ReportBuilder.build_report

  send_slack_report if ENV['SLACK_REPORT'] == 'yes'
end

def generate_report_parallel(json_input_path, report_path, start_time, tags)
  end_time = Time.now.to_i
  duration = Time.at(end_time - start_time).utc.strftime('%H:%M:%S')

  ReportBuilder.configure do |config|
    config.input_path = json_input_path
    config.report_path = report_path
    config.report_title = 'Test Result'
    config.additional_info = {
      Domain: 'POS JT Automation',
      Browser: ENV['BROWSER']&.capitalize,
      Environment: ENV['TARGET']&.capitalize,
      Tags: tags&.join(', '),
      "Run at": Time.now.strftime('%d-%m-%Y %H.%M'),
      Duration: duration
    }
    config.include_images = true
  end

  ReportBuilder.build_report
end
