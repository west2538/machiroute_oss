require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myblog
  class Application < Rails::Application

    config.load_defaults "6.0"

    config.i18n.default_locale = :ja

    config.action_cable.mount_path = '/cable'

    config.time_zone = 'Asia/Tokyo'

    config.active_storage.variant_processor = :vips

  end
end
