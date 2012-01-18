require 'csv'

namespace :db do
  desc "Add the ranking data for 2009."
  task :calc_ranking_data_2009 => :environment do
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
          #For each important statistic, we need a weighted mean and weighted standard deviation
          #after this first loop through the data, we then want to assign Z-scores to each clinic for each statistic
          #Once Z-scores are done, we want to linearize the scores/weight them based on our bell curve on the 3rd loop
          #Denominators
          total_num_embryos = 0
          total_num_cycles = 0
          
          #means
          imp_mean = 0
          birth_mean = 0
          avg_emb_mean = 0
          
          #Sums of squares of differences (for standard deviations)
          imp_ss = 0
          birth_ss = 0
          avg_emb_ss = 0
          
          #SDs
          imp_sd = 0
          birth_sd = 0
          avg_emb_sd = 0
          
          #Arrays with all the data
          clinic_ids = []
          cycles = []
          imp_rates = []
          birth_rates = []
          avg_emb_rates = []
          imp_weights = []
          birth_weights = []
          avg_emb_weights = []
          
          imp_z_scores = []
          birth_z_scores = []
          avg_emb_z_scores = []
          
          
          #Array needs to be collected with the relevant statistics
          array_index = 0
          clinics.each do |c|
            #We need to collect all cycles when computing the score for All Ages

            if(age_groups[age_group_index]=="All Ages")
              #Need to sum up the total cycles (and the total number of embryos transferred...
              #Only include clinics in this ranking who have more than 50 total cycles
              array_index += 1
              
            else #For all the other age group stuff
              #Pull out datapoint and check if there is anything
              cur_datapoint = c.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_index], :diagnosis => diagnoses[diagnosis_index])
              unless cur_datapoint.empty?
                #We only want to include clinics with >= 20 cycles in the rankings (for individual age groups)
                unless cur_datapoint.cycles < 20
                  clinic_ids[array_index] = cur_datapoint.clinic_id
                  cycles[array_index] = cur_datapoint.cycles
                  imp_rates[array_index] = cur_datapoint.implantation_rate
                  birth_rates[array_index] = cur_datapoint.births_per_cycle
                  avg_emb_rates[array_index] = cur_datapoint.avg_num_embs_transferred
                  
                  total_num_cycles += cur_datapoint.cycles
                  total_num_embryos += (cur_datapoint.cycles*cur_datapoint.avg_num_embs_transferred)
                  
                  imp_weights[array_index] = cur_datapoint.cycles*cur_datapoint.avg_num_embs_transferred*cur_datapoint.implantation_rate
                  birth_weights[array_index] = cur_datapoint.cycles*cur_datapoint.births_per_cycle
                  avg_emb_weights[array_index] = cur_datapoint.cycles*cur_datapoint.avg_num_embs_transferred
                  
                  
                  
                  array_index += 1
                end
              end
            end
            
          end #End of the clinics.each loop
          #Now cacluate the means
          

                    
          #Now we need the length of the array (array_index), and we need to loop through the array to calculate the sums of the squares of differences, and divide by the total number of datapoints minus 1

          
                    
          #Next we need to loop through the data again to assign Z-scores based on the means and SDs

                    
          
          #Finally, we need to linearize these Z-scores from 70 - 100 a la IVF Reports          

          
          
	        diagnosis_index += 1
        end
        age_group_index += 1
	    end
	    year_index += 1
    end
    
    
  end
end