class AddLatitudeToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :latitude, :float
  end
end
