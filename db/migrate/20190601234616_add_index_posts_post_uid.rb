class AddIndexPostsPostUid < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :post_uid
  end
end
