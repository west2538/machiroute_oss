Sidekiq.configure_server do |config|
    case Rails.env
      when 'production' then
        config.redis = { url: ENV.fetch('REDIS_URL'), namespace: 'sidekiq' }
      else
        config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: 'sidekiq' }
    end
end

Sidekiq.configure_client do |config|
    case Rails.env
        when 'production' then
        config.redis = { url: ENV.fetch('REDIS_URL'), namespace: 'sidekiq' }
        else
        config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: 'sidekiq' }
    end
end

Sidekiq.options[:max_retries] = 0