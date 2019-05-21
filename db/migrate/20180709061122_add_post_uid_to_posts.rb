class AddPostUidToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :post_uid, :string
  end
end
