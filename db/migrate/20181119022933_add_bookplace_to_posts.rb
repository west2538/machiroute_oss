class AddBookplaceToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :bookplace, :string
  end
end
