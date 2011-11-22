class CreateClinics < ActiveRecord::Migration
  def change
    create_table :clinics do |t|
      t.string :clinic_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :region
      t.string :practice_director
      t.string :medical_director
      t.string :laboratory_director
      t.string :phone
      t.string :website
      t.string :email
      t.string :latitude
      t.string :longitude
      t.string :info
      t.string :image

      t.timestamps
    end
  end
end
