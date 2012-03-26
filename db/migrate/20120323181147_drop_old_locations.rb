class DropOldLocations < ActiveRecord::Migration
  def up
    remove_column :clinics, :old_latitude
    remove_column :clinics, :old_longitude    
  end

  def down
    add_column :clinics, :old_latitude, :string
    add_column :clinics, :old_longitude, :string    
  end
end
