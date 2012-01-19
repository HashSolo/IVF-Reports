class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :download_csv

  def download_csv(clinic_data)
    require 'csv'
      csv_string = CSV.generate do |csv|
      	#Render the headers here
      	csv << ["clinic_id", "clinic_name"]

      	#Now cycle through the data
      	clinic_data.each do |c|
      		csv << ["#{c['clinic_id']}", "#{c['clinic_name']}"]
      	end
      end
      
      puts csv_string
	    
	    send_data csv_string, 
	                        :filename => "data-#{Time.now.to_date.to_s}.csv", 
	                        :type => "text/plain",
                          :disposition => 'attachment'
  end
end
