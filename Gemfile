source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'kaminari'
gem 'serviceworker-rails'
gem 'mastodon-api', '~> 2.0', require: 'mastodon'
gem 'omniauth-mastodon'
gem 'omniauth', git: 'https://github.com/west2538/omniauth.git', branch: 'master'
gem 'rails_autolink'
gem 'meta-tags'
gem 'gmaps4rails'
gem 'geocoder'
gem 'ffi'
gem 'sprockets-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'mini_magick'
gem 'aws-sdk-s3', require: false
gem 'acts-as-taggable-on'
gem 'nested_form_fields'
gem 'rails-i18n'
gem 'dotenv-rails'
gem 'opengraph_parser', git: 'https://github.com/huyha85/opengraph_parser.git', branch: 'master'
gem 'file_validators'
gem 'order_as_specified'
gem 'omniauth-twitter'
gem 'twitter'
gem 'toastr_rails'
gem 'google-cloud-vision'
gem 'google-protobuf', '~> 3.12.0.rc.1'
gem 'momentjs-rails'
gem 'webpush'
gem 'redis'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'redis-namespace'
gem 'grape'
gem 'grape-entity'
gem 'grape_logging'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'puma_worker_killer'
gem 'rubyzip', '>= 1.3.0'
gem 'fileutils', '~> 1.4', '>= 1.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.2.2'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
gem 'sassc'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap'
# gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'pg', '~> 1.1', '>= 1.1.4'
  #  gem 'sqlite3', '~> 1.4'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'thin', '~> 1.7', '>= 1.7.2'
  gem 'derailed_benchmarks'
end

group :test do
  gem 'pg', '~> 1.1', '>= 1.1.4'
  #  gem 'sqlite3', '~> 1.4'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  # gem 'selenium-webdriver'
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