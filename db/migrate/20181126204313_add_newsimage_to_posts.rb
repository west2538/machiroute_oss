class AddNewsimageToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :newsimage, :string
  end
end
