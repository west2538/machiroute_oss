class AddBooktitleToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :bookisbn, :string
    add_column :posts, :booktitle, :string
    add_column :posts, :bookpublisher, :string
    add_column :posts, :bookauthor, :string
    add_column :posts, :bookpubdate, :string
    add_column :posts, :bookcover, :string
  end
end
