require 'csv'

namespace :db do
  desc "Fill database with clinic data from 2006."
  task :add_clinic_data_2006 => :environment do
    #need to import the chromosome CSV file here...
    #Will import the cliic data from 2006
	  CSV.foreach("#{::Rails.root}/lib/tasks/data/clinic_data_2006.csv") do |row|
		  cur_clinic = Clinic.find_by_old_clinic_id("#{row[0]}")
      if(cur_clinic.nil?)
      
      else
	
		    Datapoint.create!(	
						:clinic_id => cur_clinic.id,
						:age_group => row[7],
						:year => row[6],
						:diagnosis => row[8],
						:cycle_type => row[9],
						:cycles => row[10],
						:implantation_rate => row[17],
						:avg_num_embs_transferred => row[18],
						:pregs_per_cycle => row[11],
						:births_per_cycle => row[12],
						:births_per_retrieval => row[13],
						:births_per_transfer => row[14],
						:set_transfer_rate => row[15],
						:cancellation_rate => row[16],
						:twin_rate => row[19],
						:trip_rate => row[20],
						:procedure_ivf_rate => row[21],
						:procedure_gift_rate => row[22],
						:procedure_zift_rate => row[23],
						:procedure_icsi_rate => row[24],
						:procedure_unstimulated_rate => row[25],
						:procedure_pgd_rate => row[26]
            )
      
        puts "Just added a datapoint for #{cur_clinic.clinic_name}. Age Group: #{row[7]} | Diagnosis: #{row[8]}"
            
      
      end
    end
  end
end