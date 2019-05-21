class Comment < ApplicationRecord
  belongs_to :post, touch: true, :counter_cache => true
  validates :body, presence: true
  has_many :notifications
  has_one_attached :image

  validates :image, file_size: { in: 10.kilobytes..10.megabytes },
    file_content_type: { allow: ['image/jpg','image/jpeg', 'image/png', 'image/gif'], message: '写真をアップロードできませんでした' }, on: :create, if: :image_attached?

  after_commit :commentmstdn_self, on: [:create, :update]
  # after_create_commit { CommentBroadcastJob.perform_later self }

  def image_attached?
    image.attached?
  end

  def commentmstdn_self
    if saved_change_to_mstdn_status?
      CommentBroadcastJob.perform_later(self)
    end
  end

end
