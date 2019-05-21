class MastodonTootJob < ApplicationJob
  queue_as :default

  def perform(domain,access_token,body_status,post)
    begin
      client = Mastodon::REST::Client.new(base_url: "https://#{domain}", bearer_token: access_token)
      res = client.create_status(body_status)
      post.mstdn_status = res.url
      post.save
    rescue => e
    end
  end
end
