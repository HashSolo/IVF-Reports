# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
IVFReports::Application.initialize!

APP_CONFIG = YAML.load(File.open("#{Rails.root}/config/app_config.yml"))