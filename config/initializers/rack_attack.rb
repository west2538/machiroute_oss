class Rack::Attack

    # 同一IPアドレスからのリクエストを5回/秒に制限
    Rack::Attack.throttle('req/ip', limit: 5, period: 1.second) do |req|
        req.ip
    end
    
    # 同一IPアドレスからのリクエストを100回/分に制限
    Rack::Attack.throttle('req/ip', :limit => 100, :period => 1.minutes) do |req|
        req.ip
    end

    Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(ENV['REDIS_URL'])

end