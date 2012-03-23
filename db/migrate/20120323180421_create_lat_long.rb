class CreateLatLong < ActiveRecord::Migration
  def up
    add_column :clinics, :latitude, :float
    add_column :clinics, :longitude, :float
  end

  def down
    remove_column :clinics, :latitude
    remove_column :clinics, :longitude    
  end
end
