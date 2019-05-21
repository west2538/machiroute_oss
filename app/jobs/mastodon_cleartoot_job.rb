class MastodonCleartootJob < ApplicationJob
  queue_as :default

  def perform(domain,access_token,comment_status,comment)
    begin
      client = Mastodon::REST::Client.new(base_url: "https://#{domain}", bearer_token: access_token)
      res = client.create_status(comment_status)
      comment.mstdn_status = res.url
      comment.save
    rescue => e
    end
  end
end
