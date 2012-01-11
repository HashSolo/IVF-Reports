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

          
	        diagnosis_index += 1
        end
        age_group_index += 1
	    end
	    year_index += 1
    end
    
    
  end
end