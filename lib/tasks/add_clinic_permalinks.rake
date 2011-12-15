require 'csv'

namespace :db do
  desc "Fill clinic table with our list of clinics."
  task :add_clinic_permalink => :environment do
  #This will add the data to the "clinics" table. Will check for uniqueness against our internal clinic_ids...these are still somewhat useful for now.
	  CSV.foreach("#{::Rails.root}/lib/tasks/data/clinic_info.csv") do |row|
	  clinic_test = Clinic.find_by_old_clinic_id(row[0])
	    if clinic_test.nil?
	    Clinic.create!(	
	      :old_clinic_id => row[0],
		    :clinic_name => row[1],
			  :address => row[2],
			  :city => row[3],
			  :state => row[4],
			  :zip => row[5],
			  :region => row[6],
			  :practice_director => row[7],
			  :laboratory_director => row[8],
			  :medical_director => row[9],
			  :phone => row[10],
			  :website => row[11],
			  :email => row[12],
			  :latitude => row[13],
			  :longitude => row[14],
			  :info => row[15],
			  :image => row[16]
			  
		    )
	    else
	      permalink = "#{clinic_test.id}-#{clinic_test.clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
	      clinic_data = {:permalink => permalink}
	      clinic_test.update_attributes(clinic_data)
	    
	    
    	  puts "Just updated the clinic #{row[1]} from #{row[3]}, #{row[4]}"
	    end	
	  end
  end
end