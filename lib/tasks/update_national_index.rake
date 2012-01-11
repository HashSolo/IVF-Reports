require 'csv'

namespace :db do
  desc "Fill clinic table with our list of clinics."
  task :update_national_index => :environment do

    #this will update the datapoints clinic_id foreign index to be 384
    datapoints = Datapoint.where(:clinic_id => 9999)
    datapoints.each do |d| 
      
      datapoint_clinic_id = d.clinic_id
      puts "Clinic_id: #{datapoint_clinic_id}"
      
      clinic_data = {:clinic_id => 384}
	    d.update_attributes(clinic_data)
      
    end
    	 
  end
end