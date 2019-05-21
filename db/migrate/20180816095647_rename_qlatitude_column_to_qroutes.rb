class RenameQlatitudeColumnToQroutes < ActiveRecord::Migration[5.2]
  def change
    rename_column :qroutes, :qlatitude, :latitude
  end
end
