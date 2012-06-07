source 'http://rubygems.org'

# Bundle edge Rails instead:

gem 'rake'#, '0.8.7'
gem 'sass'
gem 'gravatar_image_tag'#, '1.0.0.pre2'
gem 'will_paginate'#, '3.0.pre2'
gem 'aws-s3'
gem 'paperclip'
gem 'geocoder'
gem 'feedzirra'
gem 'yaml_db'
gem 'pony'

gem 'json'
gem 'haml', '3.1.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'#, "~> 3.1.0.rc"
  gem 'uglifier'
end

gem 'jquery-rails'

group :production do #comment all these out for development locally with sqlite3, etc
  gem 'rails'#,     :git => 'git://github.com/rails/rails.git', :branch => '3-1-stable' #comment out for development
  gem "therubyracer-heroku"#, "0.8.1.pre3" #comment out for development
  gem "pg"
end

group :development do
  gem 'rspec-rails', '2.6.1'
  gem 'annotate', '2.4.0'
  gem 'faker', '0.3.1'
  gem 'sqlite3'
end

group :test do
  gem 'rspec-rails', '2.6.1'
  gem 'webrat', '0.7.1'
  gem 'spork', '0.9.0.rc5'
  gem 'factory_girl_rails', '1.0'
  gem 'sqlite3'
end


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

