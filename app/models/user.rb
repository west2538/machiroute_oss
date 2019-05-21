class User < ApplicationRecord

  has_many :likes
  has_many :posts
  has_many :notifications, dependent: :destroy
  has_many :auths
  has_many :devices, dependent: :destroy
  after_update_commit :watchonline_self

  has_one_attached :image
  validates :image, file_size: { in: 10.kilobytes..10.megabytes },
  file_content_type: { allow: ['image/jpg','image/jpeg', 'image/png', 'image/gif'], message: '写真をアップロードできませんでした' }, on: :update, if: :image_attached?


    # def self.find_or_create_from_auth(auth)
    #   User.find_or_create_by(uid: auth[:uid]) do |user|
    #     user.provider = auth[:provider]
    #     user.uid = auth[:uid]
    #     user.token = auth[:credentials].token
    #   end

    def self.find_or_create_from_auth(auth)
      provider = auth[:provider]
      unless provider == 'twitter'
        uid = auth[:uid]
        token = auth[:credentials].token

        domain_array = uid.split('@')
        domain = domain_array.last
        unless domain_array[0].present?
          client = Mastodon::REST::Client.new(base_url: "https://#{domain}", bearer_token: token)
          username = client.verify_credentials.username
          uid = username + '@' + domain
        end
        self.find_or_create_by(provider: provider, uid: uid) do |user|
          user.token = token
        end
      end
    end

    def watchonline_self
      if saved_change_to_online?
        AppearanceBroadcastJob.perform_later(self)
      end
    end

    def image_attached?
      image.attached?
    end

end