class AddCommentsCountToPosts < ActiveRecord::Migration[5.2]
  def self.up
    add_column :posts, :comments_count, :integer, :null => false, :default => 0

    Post.all.each do |post|
      Post.update_counters(post.id, :comments_count => post.comments.count)
    end
  end
end
