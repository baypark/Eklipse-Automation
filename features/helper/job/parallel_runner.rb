require 'json'
require 'parallel'
require 'dotenv/load'
require 'pry'
require 'slack-ruby-block-kit'
require 'slack-ruby-client'
require_relative 'config_helper'
require_relative 'command_helper'
require_relative 'json_helper'
require_relative 'parallel_report_helper'
require_relative '../other/report_helper'

module ParallelRunnerHelper
  # Global variables
  $failed = 0
  $passed = 0
  $scenario_count = 0
  $feature_count = 0
  $scenario_name = ""
  $feature_name = ""
  $percent_passed = 0
  $percent_failed = 0

  def self.run_parallel_tests
    # set config variable
    merged_results = []
    start_time = Time.now.to_i
    formatted_time = Time.now.strftime("%H:%M")
    tags_to_run = ENV['TAGS_TO_RUN'].split(':')
    report_dir = 'features/support/reports/parallel'
    merged_json_path = "#{report_dir}/json/merged_report.json"
    html_file = "#{report_dir}/html/[#{formatted_time}]-index"

    # config parallel environment
    ConfigHelper.setup_environment
    ConfigHelper.setup_slack

    # execute test
    commands = CommandHelper.generate_commands(tags_to_run)
    CommandHelper.run_commands_in_parallel(commands, tags_to_run, report_dir, formatted_time)

    # setup reports
    JsonHelper.merge_thread_json(report_dir, merged_results, merged_json_path)
    JsonHelper.extract_scenarios_from_json(merged_json_path)

    # generate reports
    generate_report_parallel(merged_json_path, html_file, start_time, tags_to_run)
    if ENV['SLACK_REPORT']
      ReportHelper.send_slack_reports(html_file, ReportHelper.slack_messages(tags_to_run.to_s.gsub("\"", "")))
    end
  end
end
