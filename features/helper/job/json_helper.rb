require 'json'
# require_relative '../../support/slack'

module JsonHelper
  def self.merge_thread_json(report_dir, results, path)
    Dir.glob("#{report_dir}/json/thread_*.json").each do |file|
      begin
        json_data = JSON.parse(File.read(file))
        results.concat(json_data)
      rescue JSON::ParserError => e
        puts "Error parsing JSON file #{file}: #{e.message}"
      end
    end
    File.write(path, JSON.pretty_generate(results))
  end

  def self.extract_scenarios_from_json(json_file)
    scenarios = []
    json_content = File.read(json_file)
    parsed_json = JSON.parse(json_content)

    parsed_json.each do |feature|
      feature_name = feature['name']
      feature['elements'].each do |element|
        scenario_data = {
          name: element['name'],
          status: element['steps'].map { |step| step['result']['status'] }.include?('failed') ? 'failed' : 'passed',
          feature: { name: feature_name }
        }
        scenario = Scenario.new(scenario_data[:name], scenario_data[:status], scenario_data[:feature][:name])
        scenario_count(scenario)
        scenarios << scenario_data
      end
    end

    scenarios
  end

  class Scenario
    attr_accessor :name, :status, :feature

    def initialize(name, status, feature_name)
      @name = name
      @status = status
      @feature = Feature.new(feature_name)
    end
  end

  class Feature
    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
end
