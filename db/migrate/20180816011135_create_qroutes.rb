class CreateQroutes < ActiveRecord::Migration[5.2]
  def change
    create_table :qroutes do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :body
      t.string :qplacename
      t.string :qdescription
      t.float :qlatitude
      t.float :qlongitude

      t.timestamps
    end
  end
end
