class NotificationChannel < ApplicationCable::Channel

  def subscribed
    stream_from "notification_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # Notification.create! body: data['body'] 
  end

end
