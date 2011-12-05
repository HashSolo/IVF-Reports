class AddOldClinicIdToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :old_clinic_id, :integer
  end
end
