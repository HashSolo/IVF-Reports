require 'csv'

namespace :db do
  desc "Fill state table with our data for the states."
  task :add_state_data => :environment do
  #This will add the data to the "clinics" table. Will check for uniqueness against our internal clinic_ids...these are still somewhat useful for now.
	  CSV.foreach("#{::Rails.root}/lib/tasks/data/state_info.csv") do |row|
	  state_test = State.find_by_abbrev(row[0])
	    if state_test.nil?
	    State.create!(	
	      :abbrev => row[0],
		    :name => row[1],
			  :capital => row[2],
			  :population => row[3]
		  )
    	
    	puts "Just added the state #{row[1]} (#{row[0]}), with capital #{row[2]} and population #{row[3]}."
	    else
	    end	
	  end
  end
end