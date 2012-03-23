class ChangeDataTypeForLatLong < ActiveRecord::Migration
  def up
    change_column :clinics, :latitude, :float
    change_column :clinics, :longitude, :float    
  end

  def down
    change_column :clinics, :latitude, :string
    change_column :clinics, :longitude, :string
  end
end
