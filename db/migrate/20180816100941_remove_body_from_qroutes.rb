class RemoveBodyFromQroutes < ActiveRecord::Migration[5.2]
  def change
    remove_column :qroutes, :body, :string
  end
end
