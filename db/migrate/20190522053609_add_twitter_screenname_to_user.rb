class AddTwitterScreennameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :twitter_screenname, :string
  end
end
