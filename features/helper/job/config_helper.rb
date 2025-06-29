module ConfigHelper
  def self.setup_environment
    ENV['IS_PARALLEL'] = 'true'
  end

  def self.setup_slack
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
      raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
    end
  end
end
