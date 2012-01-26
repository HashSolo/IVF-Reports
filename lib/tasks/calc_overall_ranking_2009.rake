require 'csv'

namespace :db do
  desc "Add the ranking data for 2009."
  task :calc_overall_ranking_2009 => :environment do
    #This needs to, for each year, determine the national average statistics...
    #The national_average will be identified by a clinic_id of 9999
	  years = [2005, 2006, 2007, 2008, 2009]
	  age_groups = ["<35","35-37","38-40","41-42",">42", "All Ages"]
	  diagnoses = ["All Diagnoses", "Endometriosis", "Diminished Ovarian Reserve", "Multiple Female Factors", "Ovulatory Dysfunction", "Tubal Factor", "Female and Male Factors", "Male Factor", "Other Factor", "Unknown Factor", "Uterine Factor"]
	  clinics = Clinic.all
	  
	  year_index = 4 #Housekeeping for the year loop, but we should do a separate file for each year (moving forward we would only do one year at a time)
	  while(year_index < 5)
	    diagnosis_index = 0 #Housekeeping for the diagnosis loop
	    while(diagnosis_index < 11)	      
        #for each diagnostic group, we want to calculated a weighted average of all 4 scores for each clinic based on the number of cycles in each age group.
        #We then want to re-standardize and re-linearize these weighted averages in order to rank the overall scores
        #We will only do this for clinics with >=50 cycles
        #if there is no score for an age group, it is given a score of 85 and weighted by the number of cycles (or embryos for quality score)

        clinics.each do |c|
          #Now we need to cycle through all ages, calculate the weighted numbers and determine if there are 50 cycles.
          #Pull out datapoints and check if there is anything
          #Need to get the total number of cycles for this clinic...for the weighted average of each procedure
          
          #Numerators
          ivf_score_weights = 0
          quality_score_weights = 0
          safety_score_weights = 0
          sart_score_weights = 0
          
          #Denominators
          total_cycles = 0
          total_embryos = 0
          
          age_group_index = 0
          while(age_group_index < 5)
            cur_datapoint = c.datapoints.where(:year => years[year_index], :diagnosis => diagnoses[diagnosis_index], :age_group => age_groups[age_group_index])
            cur_score = c.scores.where(:year => years[year_index], :diagnosis => diagnoses[diagnosis_index], :age_group => age_groups[age_group_index])
                        
            cur_cycles = 0
            cur_avg_emb = 0
            cur_embs = cur_cycles*cur_avg_emb
            
            cur_ivf_score = 85.0
            cur_quality_score = 85.0
            cur_safety_score = 85.0
            cur_sart_score = 85.0
            
            unless cur_datapoint.empty?
              cur_cycles = cur_datapoint[0].cycles
              cur_avg_emb = cur_datapoint[0].avg_num_embs_transferred
              cur_embs = cur_cycles*cur_avg_emb
            end
              
            unless cur_score.empty?
              cur_ivf_score = cur_score[0].ivf_reports_score
              cur_quality_score = cur_score[0].quality_score
              cur_safety_score = cur_score[0].safety_score
              cur_sart_score = cur_score[0].sart_score
            end
            
            ivf_score_weights += cur_ivf_score.to_f*cur_cycles
            quality_score_weights += cur_quality_score.to_f*cur_embs
            safety_score_weights += cur_safety_score.to_f*cur_cycles
            sart_score_weights += cur_sart_score.to_f*cur_cycles
            
            total_cycles += cur_cycles
            total_embryos += cur_embs
            
          
            age_group_index += 1
          end     
          
          #Now calculate the overall scores, and add them to the database but only if there are greater than 50 total cycles
          unless(total_cycles < 50)
            overall_ivf_reports_score = ivf_score_weights.to_f/total_cycles.to_f
            overall_quality_score = quality_score_weights.to_f/total_embryos.to_f
            overall_safety_score = safety_score_weights.to_f/total_cycles.to_f
            overall_sart_score = sart_score_weights.to_f/total_cycles.to_f
                                  
            #Now insert the score into the database!   
            Score.create!(	
              :clinic_id => c.id,
              :age_group => "All Ages",
              :year => years[year_index],
              :diagnosis => diagnoses[diagnosis_index],
              :cycle_type => "fresh",
              :ivf_reports_score => overall_ivf_reports_score,
              :quality_score => overall_quality_score,
              :safety_score => overall_safety_score,
              :sart_score => overall_sart_score
            )
          
            puts "Inserted Score | Year: #{years[year_index]} Age: All | Diagnosis: #{diagnoses[diagnosis_index]} Clinic: #{c.id} | IVFr: #{overall_ivf_reports_score}, Quality: #{overall_quality_score}, Safety: #{overall_safety_score}, SART: #{overall_sart_score}"            
          end
        end #End of the clinics.each loop
        
        diagnosis_index += 1
	    end #end of the diagnosis while loop
	    
	    year_index += 1
    end #end of the year while loop
    
    puts "Rake ran without errors."
    
  end
end