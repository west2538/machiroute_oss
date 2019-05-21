class AddNoteToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :note, :string
  end
end
