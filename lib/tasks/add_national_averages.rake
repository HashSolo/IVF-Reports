require 'csv'

namespace :db do
  desc "Add the national averages for each year."
  task :add_national_averages => :environment do
    #This needs to, for each year, determine the national average statistics...
    #The national_average will be identified by a clinic_id of 9999
	  years = [2005, 2006, 2007, 2008, 2009]
	  age_groups = ["<35","35-37","38-40","41-42",">42", "All Ages"]
	  diagnoses = ["All Diagnoses", "Endometriosis", "Diminished Ovarian Reserve", "Multiple Female Factors", "Ovulatory Dysfunction", "Tubal Factor", "Female and Male Factors", "Male Factor", "Other Factor", "Unknown Factor", "Uterine Factor"]
	  clinics = Clinic.all
	  
	  year_index = 0	  
	  while(year_index < 5)
	    age_group_index = 0
	    while(age_group_index < 6)
	      diagnosis_index = 0
	      while(diagnosis_index < 11)
	        #Here the variables need to be instantiated for what we want to put into the database (the summation/average variables)
          total_cycles = 0
          avg_preg_rate = 0
          avg_birth_per_cycle = 0
          avg_birth_per_retrieval = 0
          avg_birth_per_transfer = 0
          avg_set_rate = 0
          avg_cancellation_rate = 0
          avg_imp_rate = 0
          avg_avg_num_embryos_trx = 0
          avg_twin_rate = 0
          avg_trip_rate = 0
          avg_ivf_rate = 0
          avg_gift_rate = 0
          avg_zift_rate = 0
          avg_icsi_rate = 0
          avg_unstimulated_rate = 0
          avg_pgd_rate = 0
          
          
          #here the various weighting factors should be instantiated Three possible factors: cycles, embryos, pregnancies
          weight_preg_rate = 0 #Weighted by cycles += (cur_preg_rate * cur_num_cycles)
          weight_birth_per_cycle = 0 #Weighted by cycles += (cur_birth_per_cycle_rate * cur_num_cycles)
          weight_birth_per_retrieval = 0 #Weighted by...cycles (inaccurate, but best) += (cur_birth_per_retrieval_rate * cur_num_cycles)
          weight_birth_per_transfer = 0 #Weighted by...cycles (innacurate, but best) += (cur_birth_per_tranfer_rate * cur_num_cycles)
          weight_set_rate = 0 #Weighted by cycles += (cur_set_rate * cur_num_cycles)
          weight_cancellation_rate = 0 #Weighted by cycles += (cur_cancellation_rate * cur_num_cycles)
          weight_imp_rate = 0 #Weighted by total embryos += (cur_imp_rate * cur_num_cycles * cur_avg_num_embryos_trx)
          weight_avg_num_embryos_trx = 0 #Weighted by cycles += (cur_avg_num_embryos_trx * cur_num_cycles)
          weight_twin_rate = 0 #Weighted by number of pregnancies += (cur_twin_rate * cur_num_cycles * (cur_preg_rate/100.0))
          weight_trip_rate = 0 #Weighted by number of pregnancies += (cur_trip_rate * cur_num_cycles * (cur_preg_rate/100.0))
          #Procedure rates are weighted by total cycles
          weight_ivf_rate = 0
          weight_gift_rate = 0
          weight_zift_rate = 0
          weight_icsi_rate = 0
          weight_unstimulated_rate = 0
          weight_pgd_rate = 0
          
          #define totals for denominators
          #total_cycles already defined
          total_embryos = 0 # += (cur_num_cycles * avg_num_embryos_trx)
          total_pregnancies = 0 # += (cur_num_cycles * (cur_preg_rate/100.0))
          
          
          #Now the clinic data must be summed, averaged, etc.
          
          
	        if(age_groups[age_group_index]=="All Ages") #If we are doing procedure data
            
            clinics.each do |c|
              cur_clinic_id = c.id
            
              #Need to get the total number of cycles for this clinic...for the weighted average of each procedure
              total_clinic_cycles = 0
              age_group_loop_index = 0
              while(age_group_loop_index < 5)
                cur_loop_datapoint = c.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_loop_index], :diagnosis => diagnoses[diagnosis_index])
                
                unless cur_loop_datapoint.empty?
                  total_clinic_cycles += cur_loop_datapoint[0].cycles
                end
              
                age_group_loop_index += 1
              end
              
              cur_datapoint = c.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_index], :diagnosis => diagnoses[diagnosis_index])
            
              unless cur_datapoint.empty?
                #No bearing on the national average if there is no data...
	              #Add this to the running total...for weighted average, multiply by either cycles or cycles AND avg num embryos depending on statistic (per transfer statistics also weighte dby average number of embryos transfferred, avg number of embryos transferred is weighted based on the number of cycles)
              
                #update denominators
                total_cycles += total_clinic_cycles
                
                #update weighting factors
                weight_ivf_rate += (cur_datapoint[0].procedure_ivf_rate*total_clinic_cycles)
                weight_gift_rate += (cur_datapoint[0].procedure_gift_rate*total_clinic_cycles)
                weight_zift_rate += (cur_datapoint[0].procedure_zift_rate*total_clinic_cycles)
                weight_icsi_rate += (cur_datapoint[0].procedure_icsi_rate*total_clinic_cycles)
                weight_unstimulated_rate += (cur_datapoint[0].procedure_unstimulated_rate*total_clinic_cycles)
                weight_pgd_rate += (cur_datapoint[0].procedure_pgd_rate*total_clinic_cycles)
              end
            end
            
            avg_ivf_rate = weight_ivf_rate/total_cycles
            avg_gift_rate = weight_gift_rate/total_cycles
            avg_zift_rate = weight_zift_rate/total_cycles
            avg_icsi_rate = weight_icsi_rate/total_cycles
            avg_unstimulated_rate = weight_unstimulated_rate/total_cycles
            avg_pgd_rate = weight_pgd_rate/total_cycles
            
            
            puts "Procedures Datapoint Inserted => Year|#{years[year_index]} Age|#{age_groups[age_group_index]} Diagnosis|#{diagnoses[diagnosis_index]} - | Total Cycles: #{total_cycles} | IVF Rate: #{avg_ivf_rate} | GIFT Rate: #{avg_gift_rate} | ZIFT Rate: #{avg_zift_rate} | ICSI Rate: #{avg_icsi_rate} | Unstimlated Rate: #{avg_unstimulated_rate} | PGD Rate: #{avg_pgd_rate}"
            
          else #If we are doing one of the five age groups
	        
	          clinics.each do |c|
	            cur_clinic_id = c.id
	          
	          
	          
	            #First query the database to pull out the relevant datapoint based on the year/age/diagnosis
	            cur_datapoint = c.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_index], :diagnosis => diagnoses[diagnosis_index])
	            #If the datapoint is null do nothing
	          
	            unless cur_datapoint.empty?
                #No bearing on the national average if there is no data...
	              #Add this to the running total...for weighted average, multiply by either cycles or cycles AND avg num embryos depending on statistic (per transfer statistics also weighte dby average number of embryos transfferred, avg number of embryos transferred is weighted based on the number of cycles)
              
                #update denominators
                total_cycles += (cur_datapoint[0].cycles)
                total_embryos += (cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred)
                total_pregnancies += (cur_datapoint[0].cycles*(cur_datapoint[0].pregs_per_cycle/100.0))
              
                #update weighting factors
                weight_preg_rate += (cur_datapoint[0].pregs_per_cycle * cur_datapoint[0].cycles)
                weight_birth_per_cycle += (cur_datapoint[0].births_per_cycle * cur_datapoint[0].cycles)
                weight_birth_per_retrieval += (cur_datapoint[0].births_per_retrieval * cur_datapoint[0].cycles)
                weight_birth_per_transfer += (cur_datapoint[0].births_per_transfer * cur_datapoint[0].cycles)
                weight_set_rate += (cur_datapoint[0].set_transfer_rate * cur_datapoint[0].cycles)
                weight_cancellation_rate += (cur_datapoint[0].cancellation_rate * cur_datapoint[0].cycles)
                weight_imp_rate += (cur_datapoint[0].implantation_rate * cur_datapoint[0].cycles * cur_datapoint[0].avg_num_embs_transferred)
                weight_avg_num_embryos_trx += (cur_datapoint[0].avg_num_embs_transferred * cur_datapoint[0].cycles)
                weight_twin_rate += (cur_datapoint[0].twin_rate * cur_datapoint[0].cycles * (cur_datapoint[0].pregs_per_cycle/100.0))
                weight_trip_rate += (cur_datapoint[0].trip_rate * cur_datapoint[0].cycles * (cur_datapoint[0].pregs_per_cycle/100.0))
              end
  	        end
	        
  	        #Here any processing of collected variables needs to be done
  	        avg_preg_rate = weight_preg_rate/total_cycles
            avg_birth_per_cycle = weight_birth_per_cycle/total_cycles
            avg_birth_per_retrieval = weight_birth_per_retrieval/total_cycles
            avg_birth_per_transfer = weight_birth_per_transfer/total_cycles
            avg_set_rate = weight_set_rate/total_cycles
            avg_cancellation_rate = weight_cancellation_rate/total_cycles
            avg_imp_rate = weight_imp_rate/total_embryos
            avg_avg_num_embryos_trx = weight_avg_num_embryos_trx/total_cycles
            avg_twin_rate = weight_twin_rate/total_pregnancies
            avg_trip_rate = weight_trip_rate/total_pregnancies
          
          
            
          
            puts "Datapoint Inserted => Year|#{years[year_index]} Age|#{age_groups[age_group_index]} Diagnosis|#{diagnoses[diagnosis_index]} - Total Cycles: #{total_cycles} | Implantation Rate: #{avg_imp_rate} | Birth per Cycle: #{avg_birth_per_cycle} | Birth per Retrieval: #{avg_birth_per_retrieval} | Birth per Transfer: #{avg_birth_per_transfer} | SET Rate: #{avg_set_rate} | Cancellation RatE: #{avg_cancellation_rate} | Avg Number of Embryos Trx: #{avg_avg_num_embryos_trx} | Twin Rate: #{avg_twin_rate} | Trip Rate: #{avg_trip_rate}"
	        end #End of if statement that differentiates between age groups and "All Ages"
  
          #Here the variables need to be inserted into the database        
          Datapoint.create!(	
          	:clinic_id => 9999,
          	:age_group => age_groups[age_group_index],
          	:year => years[year_index],
          	:diagnosis => diagnoses[diagnosis_index],
          	:cycle_type => "fresh",
          	:cycles => total_cycles,
          	:implantation_rate => avg_imp_rate,
          	:avg_num_embs_transferred => avg_avg_num_embryos_trx,
          	:pregs_per_cycle => avg_preg_rate,
          	:births_per_cycle => avg_birth_per_cycle,
          	:births_per_retrieval => avg_birth_per_retrieval,
          	:births_per_transfer => avg_birth_per_transfer,
          	:set_transfer_rate => avg_set_rate,
          	:cancellation_rate => avg_cancellation_rate,
          	:twin_rate => avg_twin_rate,
          	:trip_rate => avg_trip_rate,
          	:procedure_ivf_rate => avg_ivf_rate,
          	:procedure_gift_rate => avg_gift_rate,
          	:procedure_zift_rate => avg_zift_rate,
          	:procedure_icsi_rate => avg_icsi_rate,
          	:procedure_unstimulated_rate => avg_unstimulated_rate,
          	:procedure_pgd_rate => avg_pgd_rate
          )
          
	        diagnosis_index += 1
        end
        age_group_index += 1
	    end
	    year_index += 1
    end
    
    
  end
end