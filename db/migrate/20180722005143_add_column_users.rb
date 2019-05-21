class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :level, :integer
    add_column :users, :exp, :integer
    add_column :users, :hp, :integer
  end
end
