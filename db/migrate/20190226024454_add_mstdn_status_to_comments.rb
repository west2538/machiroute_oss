class AddMstdnStatusToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :mstdn_status, :string
  end
end
