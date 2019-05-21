class Like < ApplicationRecord
    belongs_to :post, counter_cache: :saves_count
    validates :user_id, {presence: true}
    validates :post_id, {presence: true}
    has_many :notifications
    # has_many :notifications, dependent: :destroy
end
