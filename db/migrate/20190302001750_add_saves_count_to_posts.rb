class AddSavesCountToPosts < ActiveRecord::Migration[5.2]
  def self.up
    add_column :posts, :saves_count, :integer, :null => false, :default => 0

    Post.all.each do |post|
      Post.update_counters(post.id, :saves_count => post.likes.count)
    end
  end
end
