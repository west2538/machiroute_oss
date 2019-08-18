require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myblog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults "6.0"

    config.i18n.default_locale = :ja

    config.action_cable.mount_path = '/cable'

    config.time_zone = 'Asia/Tokyo'

    # config.session_store_servers = ENV['REDISTOGO_URL']
    # config.session_store_servers = ENV['REDIS_URL']

    # api
    # config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    # config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]

    # config.middleware.use Rack::Attack

    # unless Rails.env.production?
    #   config.web_console.whitelisted_ips = '192.168.1.37'
    # end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
