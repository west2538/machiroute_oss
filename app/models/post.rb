class Post < ApplicationRecord

    acts_as_ordered_taggable_on :labels
    acts_as_taggable
    extend OrderAsSpecified

    has_one_attached :image

    after_commit :watchmstdn_self, on: [:create, :update]
    after_commit :annotate_self, on: [:create, :update]

    # after_create_commit :watchmstdn_self
    # after_update_commit :watchmstdn_self
    # after_create_commit { PostBroadcastJob.perform_later self }

    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :notifications, dependent: :destroy
    has_many :qroutes, dependent: :destroy
    accepts_nested_attributes_for :qroutes, allow_destroy: true

    validates :body, presence: { message: '4～300文字で入力してください' }, length: { in: 4..300, message: '4～300文字で入力してください' }
    with_options if: :book_select? do
        validates :bookisbn, presence: { message: '本の裏表紙に記載のISBNコードを入力して検索ボタンを押してね' }
        validates :bookauthor, presence: true
    end
    validates :placename, presence: { message: 'Googleマップに登録されている住所もしくはスポット名を入力してください' }, if: :guild_select?
    validates :newsurl, format: { with: /\A#{URI::regexp(%w(http https))}\z/, message: '正しいURLをペーストしてください' }, if: :news_select?
    validates :stationname, presence: { message: '最寄りの駅が指定されていません' }, if: :station_select?
    validates :image, file_size: { in: 1.kilobytes..10.megabytes },
    file_content_type: { allow: ['image/jpg','image/jpeg', 'image/png', 'image/gif'], message: '写真をアップロードできませんでした' }, on: :create, if: :image_attached?

    geocoded_by :placename
    after_validation :geocode, if: :placename_changed?

    # default_scope -> { order(created_at: :desc) }
    # paginates_per 20  # 1ページあたりの項目数

    def self.cache_all
        Rails.cache.fetch("posts"){Post.all}
    end

    def book_select?
        title == "書籍や漫画を読んだ"
    end

    def guild_select?
        title == "冒険の拠点を登録"
    end

    def news_select?
        title == "ニュース"
    end

    def station_select?
        title == "駅でチェックイン"
    end

    def image_attached?
        image.attached?
    end

    def watchmstdn_self
        res = self.previous_changes
        if res['title']
            if res['title'].include?("新規サブクエスト") && res['created_at']
                PostBroadcastJob.perform_later(self)
            end
        elsif saved_change_to_mstdn_status?
            PostBroadcastJob.perform_later(self)
        end
    end

    def annotate_self
        if image.attached?
            ImageAnnotateJob.set(wait: 10.second).perform_later(self)
        end
    end

end