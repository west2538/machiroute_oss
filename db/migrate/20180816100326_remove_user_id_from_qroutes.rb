class RemoveUserIdFromQroutes < ActiveRecord::Migration[5.2]
  def change
    remove_column :qroutes, :user_id, :integer
  end
end
