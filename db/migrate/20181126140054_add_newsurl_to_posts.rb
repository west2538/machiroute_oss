class AddNewsurlToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :newsurl, :string
  end
end
