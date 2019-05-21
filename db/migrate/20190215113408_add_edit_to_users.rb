class AddEditToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :fields1_name, :string
    add_column :users, :fields1_value, :string
    add_column :users, :fields2_name, :string
    add_column :users, :fields2_value, :string
    add_column :users, :fields3_name, :string
    add_column :users, :fields3_value, :string
    add_column :users, :fields4_name, :string
    add_column :users, :fields4_value, :string
  end
end
