module Entities
  module V1
    class NotificationEntity < RootEntity
      expose :notified_type, :created_at
    end
  end
end