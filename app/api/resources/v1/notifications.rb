module Resources
  module V1
    class Notifications < Grape::API
      resources :notifications do

        # /api/v1/notifications
        desc '特定のユーザーに通知を送信します'
        params do
          requires :since_id, type: Integer, desc: '通知ID'
          requires :send_to_uid, type: String, desc: '通知先のUID'
          requires :send_from_uid, type: String, desc: '通知元のUID'
          requires :notified_type, type: String, desc: '通知タイプ'
        end
        post do
          authenticate!
          return unless params[:notified_type] == 'mastodon'
          send_to_user = User.find_by(uid: params[:send_to_uid])
          send_from_user = User.find_by(uid: params[:send_from_uid])
          return unless send_from_user
          @notification = Notification.new(user_id: send_to_user.id, notified_by_id: send_from_user.id, notified_type: params[:notified_type], post_id: 1)
          if @notification.save
            status 201
            present @notification, with: Entities::V1::NotificationEntity
          else
            status 400
            present @notification.errors
          end
          send_to_user.since_id = params[:since_id]
          send_to_user.save
        end

      end
    end
  end
end