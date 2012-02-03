class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permalink, :string
    
    #Extended Demographic Information
    add_column :users, :gender, :string
    add_column :users, :zip_code, :string
    add_column :users, :ethnicity, :string
    add_column :users, :birthday, :date
    
    #Basic Fertility Information
    add_column :users, :previous_cycles, :integer
    add_column :users, :infertility_diagnosis, :string
    
    #Blood Type and Rh Factor (If Known)
    add_column :users, :abo_blood_type, :string
    add_column :users, :rh_factor, :string
    
    #Basic Medical Information - Used to determine BMI
    add_column :users, :height_ft, :integer
    add_column :users, :height_inches, :integer
    add_column :users, :weight, :weight
        
    #Hormonal Labs - FSH, LH, and E2 (Days 3 and 10) & Prolactin
    add_column :users, :day_3_fsh, :float
    add_column :users, :day_3_e2, :float
    add_column :users, :day_3_lh, :float
    add_column :users, :day_10_fsh, :float
    add_column :users, :day_10_e2, :float
    add_column :users, :day_10_lh, :float
    add_column :users, :prolactin, :float
    
    #Saline Sonogram Information - Fibroids and Tumors
    add_column :users, :uterine_fibroids, :string
    add_column :users, :uterine_tumors, :string
    
  end
end
