class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    user = User.find_by(id: notification.user_id)
    ActionCable.server.broadcast 'notification_channel', { uid: user.uid, id: notification.id, user_id: notification.user_id, notified_type: notification.notified_type, created_at: notification.created_at }
  end
end
