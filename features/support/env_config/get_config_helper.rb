# def get_config_data(key)
#   target = (ENV["TARGET"] || "default").downcase
#   YAML.load_file("config/data-target-#{target}.yml")[key]
# end

# def get_config_product_data(key)
#   target = (ENV["TARGET"] || "default").downcase
#   YAML.load_file("config/data-product-#{target}.yml")[key]
# end

# require 'yaml'

# def safe_env(key, fallback = 'default')
#   ENV[key]&.downcase || fallback
# end

# def load_config_file(path)
#   unless File.exist?(path)
#     # puts "❌ Missing config file: #{path}"
#     raise "Configuration file not found: #{path}"
#   end
#   YAML.load_file(path)
# end

# def get_config_data(key)
#   target = safe_env("TARGET")
#   file_path = "config/data-target-#{target}.yml"
#   load_config_file(file_path)[key]
# end

# def get_config_product_data(key)
#   target = safe_env("TARGET")
#   file_path = "config/data-product-#{target}.yml"
#   load_config_file(file_path)[key]
# end

def get_config_data(key)
  YAML.load_file("config/data-target-" + ENV["TARGET"].downcase + ".yml")[key]
end

def get_config_product_data(key)
  YAML.load_file("config/data-product-" + ENV["TARGET"].downcase + ".yml")[key]
end

def get_config_payment_cc_data
  config_file = ENV["TARGET"].eql?('prod') ? "config/data-paym-cc-prod.yml" : "config/data-paym-cc-devstg.yml"
  YAML.load_file(config_file)
end