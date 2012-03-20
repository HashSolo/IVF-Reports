require 'csv'

namespace :db do
  desc "Fill database with clinic data from 2005."
  task :export_clinic_data => :environment do
    #need to import the chromosome CSV file here...
    #Will import the clinic data from 2005
    path = "#{::Rails.root}/lib/tasks/data/all_clinic_data.csv"
    clinics = Clinic.all
	  CSV.open(path, "wb", :col_sep => ',') do |row|
	    clinics.each do |c|
	      datapoints = c.datapoints
	      datapoints.each do |d| 
          row << [c.clinic_name, c.address, c.city, c.state, c.zip, c.practice_director, c.phone, d.cycle_type, d.year, d.age_group, d.diagnosis, d.cycles, d.implantation_rate, d.avg_num_embs_transferred, d.pregs_per_cycle, d.births_per_cycle, d.births_per_retrieval, d.births_per_transfer, d.set_transfer_rate, d.cancellation_rate, d.twin_rate, d.trip_rate, d.procedure_ivf_rate, d.procedure_gift_rate, d.procedure_zift_rate, d.procedure_icsi_rate, d.procedure_unstimulated_rate, d.procedure_pgd_rate]
          puts "Writing datapoint Clinic: #{c.clinic_name}, Year: #{d.year}, Age: #{d.age_group}, Diagnosis: #{d.diagnosis}."
        end
      end

    end
  end
end