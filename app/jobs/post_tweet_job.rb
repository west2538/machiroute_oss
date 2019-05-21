class PostTweetJob < ApplicationJob
  queue_as :default

  def perform(body_status,access_token,access_token_secret)
    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = access_token
        config.access_token_secret = access_token_secret
      end
      client.update(body_status)
    rescue => e
    end
  end
end
