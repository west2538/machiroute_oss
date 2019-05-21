class AddShogoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :shogo, :string
  end
end
