class AddUserUidToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :user_uid, :string
  end
end
