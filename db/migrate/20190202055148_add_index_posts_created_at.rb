class AddIndexPostsCreatedAt < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :created_at
  end
end
