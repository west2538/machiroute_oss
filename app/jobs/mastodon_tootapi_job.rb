class MastodonTootapiJob < ApplicationJob
  queue_as :default

  def perform(domain,access_token,url,post)
    begin
      if post.title == 'ニュース'
        body_status = post.body + " " + post.newsurl
      elsif post.title == '駅でチェックイン'
        body_status = post.body + " at " + post.stationname + " " + url
      else
        body_status = post.body
      end
      client = Mastodon::REST::Client.new(base_url: "https://#{domain}", bearer_token: access_token)
      res = client.create_status(body_status)
      post.mstdn_status = res.url
      post.save
    rescue => e
    end
  end
end
