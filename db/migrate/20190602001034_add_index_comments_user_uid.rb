class AddIndexCommentsUserUid < ActiveRecord::Migration[5.2]
  def change
    add_index :comments, :user_uid
  end
end
