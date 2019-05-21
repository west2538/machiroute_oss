class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    member = User.where(id: current_user.id).first
    return unless member

    # Mastodonの通知の有無をチェック
    unless member.since_id.present?
      member.since_id = 1;
    end

    begin
      domain_array = member.uid.split('@')
      domain = domain_array.last
      uri = URI.parse("https://#{domain}/api/v1/notifications?bearer_token=#{member.token}&since_id=#{member.since_id}")
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)
      unless result[0].nil?
        if result[0]['id'].to_i > member.since_id
          member.since_id = result[0]['id'].to_i
          member.save
          send_from_user_url = result[0]['account']['url'].to_s
          send_from_user_url2 = send_from_user_url.gsub("https://", "")
          send_from_user_bunkatsu = send_from_user_url2.split("/@")
          send_from_user_uid = send_from_user_bunkatsu[1] + "@" + send_from_user_bunkatsu[0]
          send_from_user = User.find_by(uid: send_from_user_uid)
          if send_from_user.present?
            @notification = Notification.new(user_id: member.id, notified_by_id: send_from_user.id, notified_type: 'mastodon', post_id: 1)
            @notification.save
          end
        end
      end
    rescue => e
    end

    member.update_attributes(online: true, online_at: DateTime.now)
    stream_from "appearance_user"
  end

  def unsubscribed
    member = User.where(id: current_user.id).first
    return unless member
    member.update_attributes(online: false, online_at: DateTime.now)
  end
end