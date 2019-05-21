class RenameQlongitudeColumnToQroutes < ActiveRecord::Migration[5.2]
  def change
    rename_column :qroutes, :qlongitude, :longitude
  end
end
