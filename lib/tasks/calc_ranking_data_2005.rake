require 'csv'

namespace :db do
  desc "Add the ranking data for 2005."
  task :calc_ranking_data_2005 => :environment do
    #This needs to, for each year, determine the national average statistics...
    #The national_average will be identified by a clinic_id of 9999
	  years = [2005, 2006, 2007, 2008, 2009]
	  age_groups = ["<35","35-37","38-40","41-42",">42", "All Ages"]
	  diagnoses = ["All Diagnoses", "Endometriosis", "Diminished Ovarian Reserve", "Multiple Female Factors", "Ovulatory Dysfunction", "Tubal Factor", "Female and Male Factors", "Male Factor", "Other Factor", "Unknown Factor", "Uterine Factor"]
	  clinics = Clinic.all
	  
	  year_index = 0 #Housekeeping for the year loop, but we should do a separate file for each year (moving forward we would only do one year at a time)
	  while(year_index < 1)
	    diagnosis_index = 0 #Housekeeping for the diagnosis loop
	    while(diagnosis_index < 11)
	      age_group_index = 0 #Housekeeping for the age-group loop
	      while(age_group_index < 5)
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
          
          #Arrays with z-scores
          imp_z_scores = []
          birth_z_scores = []
          avg_emb_z_scores = []
          
          #Final Scores
          ivf_reports_final_scores = []
          imp_final_scores = []
          birth_final_scores = []
          avg_emb_final_scores = []
          
          
          #Array needs to be collected with the relevant statistics
          array_index = 0
          clinics.each do |c|
            #We need a separate rake task for 'All Ages'
              
            #Pull out datapoints and check if there is anything
            cur_datapoint = c.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_index], :diagnosis => diagnoses[diagnosis_index])
            unless cur_datapoint.empty?
              #We only want to include clinics with >= 10 cycles in the rankings (for individual age groups)
              unless cur_datapoint[0].cycles < 10 || cur_datapoint[0].clinic_id == 384
                clinic_ids[array_index] = cur_datapoint[0].clinic_id
                cycles[array_index] = cur_datapoint[0].cycles
                imp_rates[array_index] = cur_datapoint[0].implantation_rate
                birth_rates[array_index] = cur_datapoint[0].births_per_cycle
                avg_emb_rates[array_index] = cur_datapoint[0].avg_num_embs_transferred
                  
                total_num_cycles += cur_datapoint[0].cycles
                total_num_embryos += (cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred)
                  
                imp_weights[array_index] = cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred*cur_datapoint[0].implantation_rate
                birth_weights[array_index] = cur_datapoint[0].cycles*cur_datapoint[0].births_per_cycle
                avg_emb_weights[array_index] = cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred
                  
                array_index += 1
              end #unless cycles < 10
            end #unless cur_datapoint is empty
            
          end #End of the clinics.each loop

          if(array_index==0) #If no Clinics have > 10 cycles for this category...SKIP
            
          else
            #Now cacluate the means
            imp_mean = imp_weights.sum/total_num_embryos
            birth_mean = birth_weights.sum/total_num_cycles
            avg_emb_mean = total_num_embryos/total_num_cycles
          
            puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} Diagnosis: #{diagnoses[diagnosis_index]}  | Implantation Mean: #{imp_mean}."
            puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} Diagnosis: #{diagnoses[diagnosis_index]}  | Birth Mean: #{birth_mean}."
            puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} Diagnosis: #{diagnoses[diagnosis_index]}  | Avg Emb Mean: #{avg_emb_mean}."
          
            #Now we need the length of the array (array_index), and we need to loop through the array to calculate the sums of the squares of differences, and divide by the total number of datapoints minus 1
            calculation_index = 0
            while(calculation_index < array_index)
              imp_ss += ((imp_rates[calculation_index] - imp_mean)**2)*cycles[calculation_index]*avg_emb_rates[calculation_index] #This value eventually has to be divided by the total number of embryos
              birth_ss += ((birth_rates[calculation_index] - birth_mean)**2)*cycles[calculation_index] #This value needs to be divided by the total number of cycles
              avg_emb_ss += ((avg_emb_rates[calculation_index] - avg_emb_mean)**2)*cycles[calculation_index] #This value needs to be divided by the total number of cycles eventually
              calculation_index += 1
            end
          
            #calculate the standard deviations
            imp_sd = Math.sqrt(imp_ss/total_num_embryos)
            birth_sd = Math.sqrt(birth_ss/total_num_cycles)
            avg_emb_sd = Math.sqrt(avg_emb_ss/total_num_cycles)
          
          
            puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} Diagnosis: #{diagnoses[diagnosis_index]}  | Implantation SD: #{imp_sd}."
            puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} Diagnosis: #{diagnoses[diagnosis_index]}  | Birth SD: #{birth_sd}."
            puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} Diagnosis: #{diagnoses[diagnosis_index]}  | Avg Emb SD: #{avg_emb_sd}."
          
            #Next we need to loop through the data again to assign Z-scores based on the means and SDs 
            z_calc_index = 0
            while(z_calc_index < array_index)
              if(imp_sd==0)
                imp_z_scores[z_calc_index] = 0.0
              else
                imp_z_scores[z_calc_index] = (imp_rates[z_calc_index].to_f - imp_mean.to_f)/imp_sd.to_f
              end
            
              if(birth_sd==0)
                birth_z_scores[z_calc_index] = 0.0
              else
                birth_z_scores[z_calc_index] = (birth_rates[z_calc_index].to_f - birth_mean.to_f)/birth_sd.to_f
              end

              if(avg_emb_sd==0)
                avg_emb_z_scores[z_calc_index] = 0.0
              else
                #Z scores are inversed here to make sure lower rates get higher scores
                avg_emb_z_scores[z_calc_index] = (-1)*((avg_emb_rates[z_calc_index].to_f - avg_emb_mean.to_f)/avg_emb_sd.to_f)
              end        
            
              z_calc_index += 1
            end
          
            #Finally, we need to linearize these Z-scores from 70 - 100 a la IVF Reports          
            #I've made the decision to keep the scale between -3.0 and 3.0 no matter what....meaning if the highest/lowest doesn't reach, we are not linearizing to those numebrs. There may, in some cases, not be anyone who scores 100 (or 70)
            #Linearization will occur on 5 point intervals: 70-75 = -3 - -2; 75-80 = -2 to -1; 80-85 = -1 - 0; 85 - 90 = 0 - 1; 90 - 95 = 1 - 2; 95 - 100 = 2 - 3
            #Anything less than -3 = 70, and anything > 3 = 100
            score_calc_index = 0
            b_value = 85
            m_value = 5
            while(score_calc_index < array_index)
              if(imp_z_scores[score_calc_index] > 3.0)
                imp_final_scores[score_calc_index] = 100.0
              elsif(imp_z_scores[score_calc_index] < -3.0)
                imp_final_scores[score_calc_index] = 70.0
              else
                imp_final_scores[score_calc_index] = m_value*(imp_z_scores[score_calc_index]) + b_value
              end
            
              if(birth_z_scores[score_calc_index] > 3.0)
                birth_final_scores[score_calc_index] = 100.0
              elsif(birth_z_scores[score_calc_index] < -3.0)
                birth_final_scores[score_calc_index] = 70.0
              else
                birth_final_scores[score_calc_index] = m_value*(birth_z_scores[score_calc_index]) + b_value
              end
            
              if(avg_emb_z_scores[score_calc_index] > 3.0)
                avg_emb_final_scores[score_calc_index] = 100.0
              elsif(avg_emb_z_scores[score_calc_index] < -3.0)
                avg_emb_final_scores[score_calc_index] = 70.0
              else
                avg_emb_final_scores[score_calc_index] = m_value*(avg_emb_z_scores[score_calc_index]) + b_value
              end

              ivf_reports_final_scores[score_calc_index] = (imp_final_scores[score_calc_index] + avg_emb_final_scores[score_calc_index])/2
            
            
              #Now insert the score into the database!
              #Here the variables need to be inserted into the database        
              Score.create!(	
              	:clinic_id => clinic_ids[score_calc_index],
              	:age_group => age_groups[age_group_index],
              	:year => years[year_index],
              	:diagnosis => diagnoses[diagnosis_index],
              	:cycle_type => "fresh",
              	:ivf_reports_score => ivf_reports_final_scores[score_calc_index],
              	:quality_score => imp_final_scores[score_calc_index],
              	:safety_score => avg_emb_final_scores[score_calc_index],
            	  :sart_score => birth_final_scores[score_calc_index]
              )
            
              puts "Inserted Score for Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} Diagnosis: #{diagnoses[diagnosis_index]} Clinic ID: #{clinic_ids[score_calc_index]} | IVFr Score: #{ivf_reports_final_scores[score_calc_index]}, Quality Score: #{imp_final_scores[score_calc_index]}, Safety Score: #{avg_emb_final_scores[score_calc_index]}, SART Score: #{birth_final_scores[score_calc_index]}."
            
            
              score_calc_index += 1;
            end #End the score_calc_index loop
          end #End if array_index == 0 if statement
          age_group_index += 1
        end #end of the age group while loop
        diagnosis_index += 1
	    end #end of the diagnosis while loop
	    year_index += 1
    end #end of the year while loop
    
    puts "Rake ran without errors."
    
  end
end