class AddClinicianToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clinician, :boolean, :default => false
  end
end
