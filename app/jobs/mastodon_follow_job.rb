class MastodonFollowJob < ApplicationJob
  queue_as :default

  def perform(domain,master_token,follow_uid,access_token)

    client = Mastodon::REST::Client.new(base_url: "https://#{domain}", bearer_token: access_token)

    # 新規アカウントからマスターをフォロー
    if domain == 'another-guild.com'
      unless follow_uid == 'townsguild@another-guild.com'
        uri = URI.parse("https://#{domain}/api/v1/accounts/relationships?bearer_token=#{access_token}&id=1")
        json = Net::HTTP.get(uri)
        result = JSON.parse(json)
        if result[0]['following'].to_s == 'false'
          client.follow(1) # 1: townsguild@another-guild.com
        end
      end
    else
      # 新規アカウントからマスターをリモートフォロー
      uri = URI.parse("https://#{domain}/api/v1/follows?uri=townsguild@another-guild.com&bearer_token=#{access_token}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data({'uri' => 'townsguild@another-guild.com', 'bearer_token' => access_token})
      res = http.request(req)
    end

    # マスターからのフォロー返し
    uri = URI.parse("https://another-guild.com/api/v1/follows?uri=#{follow_uid}&bearer_token=#{master_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data({'uri' => follow_uid, 'bearer_token' => master_token})
    res = http.request(req)
  end
end
