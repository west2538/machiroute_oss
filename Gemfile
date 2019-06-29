source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'kaminari'
gem 'serviceworker-rails'
gem 'mastodon-api', '~> 2.0', require: 'mastodon'
gem 'omniauth-mastodon'
gem 'omniauth', github: 'west2538/omniauth', tag: 'csslinktag34'
gem 'rails_autolink'
gem 'meta-tags', '~> 2.11'
gem 'gmaps4rails'
gem 'geocoder', '~> 1.5', '>= 1.5.1'
gem 'ffi', '~> 1.11', '>= 1.11.1'
gem 'sprockets-rails', '~> 3.2', '>= 3.2.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'aws-sdk-s3', require: false
gem 'mini_magick', '~> 4.9', '>= 4.9.2'
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'acts-as-taggable-on'
gem 'nested_form_fields'
gem 'rails-i18n', '~> 5.1', '>= 5.1.2'
gem 'dotenv-rails'
gem 'opengraph_parser'
gem 'file_validators'
gem 'order_as_specified'
gem 'omniauth-twitter'
gem 'twitter'
gem 'browser', '~> 2.5', '>= 2.5.3'
gem 'toastr_rails'
gem 'rack-attack'
gem 'google-cloud-vision', '~> 0.33.1'
gem 'google-protobuf', '~> 3.8'
gem 'momentjs-rails'
gem 'webpush', '~> 0.3.6'
gem 'redis', '~> 4.1'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'redis-namespace'
gem 'grape'
gem 'grape-entity'
gem 'grape_logging'
gem 'grape-swagger'
gem 'grape-swagger-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 4.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.4', '>= 1.4.3'
# gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'sqlite3', '~> 1.3.6'
  # gem 'sqlite3'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 3.7'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'thin', '~> 1.7', '>= 1.7.2'
  gem 'derailed_benchmarks'
end

group :test do
  gem 'sqlite3', '~> 1.3.6'
  # gem 'sqlite3'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'pg', '~> 1.1', '>= 1.1.4'
  gem 'heroku-deflater', '~> 0.6.3'
  gem 'sqreen'
end