class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  helper_method :download_csv
  
  def download_csv(clinic_data)
    require 'csv'
      csv_string = CSV.generate do |csv|
      	#Render the headers here
      	csv << ['clinic_id', 'clinic_name', 'city', 'state', 'address', 'zip', 'practice_director', 'medical_director', 'lab_director', 'year', 'age_group', 'diagnosis', 'cycles', 'avg_num_embryos_trx', 'implantation_rate', 'pregnancy_rate', 'births_per_cycle', 'births_per_retrieval', 'births_per_transfer', 'set_rate', 'cancellation_rate', 'twin_rate', 'trip_rate', 'last_updated']

      	#Now cycle through the data
      	clinic_data.each do |c|
      		csv << [
      		  c['clinic_id'],
      		  c['clinic_name'],
      		  c['address'],
      		  c['city'],
      		  c['state'],
      		  c['zip'],
      		  c['practice_director'],
      		  c['medical_director'],
      		  c['lab_director'],
      		  c['year'],
      		  c['age_group'],
      		  c['diagnosis'],
      		  c['cycles'],
      		  c['avg_num_embs_transferred'],
      		  c['implantation_rate'],
      		  c['pregnancy_rate'],
      		  c['birth_cycle_rate'],
      		  c['birth_retrieval_rate'],
      		  c['birth_transfer_rate'],
      		  c['set_transfer_rate'],
      		  c['cancellation_rate'],
            c['twin_rate'],
      		  c['trip_rate'],
      		  c['updated_at']
      		  ]
      	end
      end
      
	    @outfile = "data-#{Time.now.to_date.to_s}.csv"

	    send_data csv_string, 
                          :type => 'text/csv; charset=iso-8859-1; header=present',
                          :disposition => 'attachment',
                          :filename =>  @outfile
  end
  
  
end
