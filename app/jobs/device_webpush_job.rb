class DeviceWebpushJob < ApplicationJob
  queue_as :default

  def perform(user_ids)
    @devices = Device.where(user_id: user_ids).order(created_at: :desc).limit(5)
    if @devices.present?
        @devices.each do |device|
          begin
            Webpush.payload_send(
                message: 'あなたのサブクエストがクリアされました',
                endpoint: device.endpoint,
                p256dh: device.p256dh,
                auth: device.auth,
                ttl: 12 * 60 * 60,
                vapid: {
                    public_key: ENV['VAPID_PUBLIC_KEY'],
                    private_key: ENV['VAPID_PRIVATE_KEY'],
                    expiration: 12 * 60 * 60
                }
            )
          rescue => e
          end
        end
    end
  end
end
