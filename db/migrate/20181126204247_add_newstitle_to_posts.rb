class AddNewstitleToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :newstitle, :string
  end
end
