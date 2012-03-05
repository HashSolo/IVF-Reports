require 'csv'

namespace :db do
  desc "Add the national averages for each year."
  task :random_task => :environment do
    datapoints = Datapoint.where(:clinic_id => 9999)
    
    datapoints.each do |d|
      d.update_attributes(
        :clinic_id => 384
      )
      puts "Updated datapoint #{d.id}"
    end
    
    
    
  end
end