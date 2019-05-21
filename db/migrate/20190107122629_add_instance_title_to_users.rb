class AddInstanceTitleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :instance_title, :string
  end
end
