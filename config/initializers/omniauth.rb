Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mastodon,
    scope: 'read write follow',
    credentials: lambda { |domain, callback_url|
    Rails.logger.info "Requested credentials for #{domain} with callback URL #{callback_url}"
 
    existing = MastodonClient.find_by(domain: domain)
    return [existing.client_id, existing.client_secret] unless existing.nil?
 
    client = Mastodon::REST::Client.new(base_url: "https://#{domain}")
    app = client.create_app('まちかどルート', callback_url, 'read write follow')
    
    MastodonClient.create!(domain: domain, client_id: app.client_id, client_secret: app.client_secret)
 
    [app.client_id, app.client_secret]
    }

  provider :twitter,
  ENV['TWITTER_CONSUMER_KEY'],
  ENV['TWITTER_CONSUMER_SECRET']

end