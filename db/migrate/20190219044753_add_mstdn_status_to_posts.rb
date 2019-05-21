class AddMstdnStatusToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :mstdn_status, :string
  end
end
