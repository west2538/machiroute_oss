class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :endpoint, :null => false
      t.string :p256dh, :null => false
      t.string :auth, :null => false

      t.timestamps
    end
  end
end
