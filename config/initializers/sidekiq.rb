Sidekiq.configure_server do |config|
    case Rails.env
      when 'production' then
        config.redis = { url: 'redis://h:p4a9da922de13785bbc8726216a72635515af95a1f46686858df79a6910c50bfb@ec2-34-206-59-95.compute-1.amazonaws.com:29469', namespace: 'sidekiq' }
      else
        config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: 'sidekiq' }
    end
end

Sidekiq.configure_client do |config|
    case Rails.env
        when 'production' then
        config.redis = { url: 'redis://h:p4a9da922de13785bbc8726216a72635515af95a1f46686858df79a6910c50bfb@ec2-3-213-150-12.compute-1.amazonaws.com:20939', namespace: 'sidekiq' }
        else
        config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: 'sidekiq' }
    end
end

Sidekiq.options[:max_retries] = 0