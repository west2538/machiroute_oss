class AddPlacenameToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :placename, :string
  end
end
