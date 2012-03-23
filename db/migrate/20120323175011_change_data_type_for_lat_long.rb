class ChangeDataTypeForLatLong < ActiveRecord::Migration
  def up
    rename_column :clinics, :latitude, :old_latitude
    rename_column :clinics, :longitude, :old_longitude
  end

  def down
    rename_column :clinics, :old_latitude, :latitude
    rename_column :clinics, :old_longitude, :longitude
  end
end
