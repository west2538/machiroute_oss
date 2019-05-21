class Notification < ApplicationRecord
  belongs_to :notified_by, class_name: 'User'
  belongs_to :user
  belongs_to :post

  after_commit :watchmstdn_self, on: [:create, :update]

  def watchmstdn_self
    res = self.previous_changes
    if res['notified_type'] && res['created_at']
      NotificationBroadcastJob.perform_later(self)
    end
  end

end
