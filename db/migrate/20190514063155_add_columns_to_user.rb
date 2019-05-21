class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :since_id, :integer
  end
end
