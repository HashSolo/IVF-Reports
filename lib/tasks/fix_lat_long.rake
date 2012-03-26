require 'csv'

namespace :db do
  desc "Move the old string data to the new lat long columns."
  task :fix_lat_long => :environment do
    CSV.foreach("#{::Rails.root}/lib/tasks/data/clinic_info.csv") do |row|
	  cur_clinic = Clinic.find_by_old_clinic_id(row[0])
	    if cur_clinic.nil? 
        # If no clinic exists, do nothing
      else
        cur_clinic.update_attributes(
  	          :latitude => row[13],
      			  :longitude => row[14]
  	    )
  	    puts "Updated Clinic: #{cur_clinic.clinic_name}"
      end
	  end
  end
end