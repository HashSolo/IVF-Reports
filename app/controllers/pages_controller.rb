class PagesController < ApplicationController
  def home
  end

  def about
    @title = "About Us"
  end

  def contact
    @title = "Contact Us"
  end
  
  def clinicfind
    @title = "Find a Clinic"
  	year = 2009
  	age = "All Ages"
  	diagnosis = "All Diagnoses"
  	cycle_type = "fresh"
  	
  	respond_to do |format|
  	  format.html {}
  	  format.json do 
  	    @clinics = Clinic.all
        @clinic_results = Array.new;
        @clinics.each do |c|
          if(c.id==384)

          else
            cur_score = Score.where(:clinic_id => c.id, :year => year, :age_group => age, :diagnosis => diagnosis, :cycle_type => cycle_type)
            if cur_score.empty?
              cur_new_object = {'year' => year, 'age_group' => age, 'diagnosis' => diagnosis, 'ivf_reports_score' => 0.00, 'quality_score' => 0.00, 'safety_score' => 0.00, 'sart_score' => 0.00, 'clinic_id' => c.id, 'clinic_name' => c.clinic_name, 'permalink' => c.permalink, 'city' => c.city, 'state' => c.state, 'address' => c.address, 'practice_director' => c.practice_director, 'lab_director' => c.laboratory_director, 'medical_director' => c.medical_director, 'zip' => c.zip, 'info' => c.info, 'latitude' => c.latitude, 'longitude' => c.longitude}
            else
              cur_new_object = {'updated_at' => cur_score[0].updated_at, 'year' => cur_score[0].year, 'age_group' => cur_score[0].age_group, 'diagnosis' => cur_score[0].diagnosis, 'ivf_reports_score' => cur_score[0].ivf_reports_score, 'quality_score' => cur_score[0].quality_score, 'safety_score' => cur_score[0].safety_score, 'sart_score' => cur_score[0].sart_score, 'clinic_id' => c.id, 'clinic_name' => c.clinic_name, 'permalink' => c.permalink, 'city' => c.city, 'state' => c.state, 'address' => c.address, 'practice_director' => c.practice_director, 'lab_director' => c.laboratory_director, 'medical_director' => c.medical_director, 'zip' => c.zip, 'info' => c.info, 'latitude' => c.latitude, 'longitude' => c.longitude}
            end
            @clinic_results << cur_new_object
          end
        end
  	    render :json => @clinic_results.to_json()
	    end
	  end
  end
  
  def loadclinicdata
    
  end
  
  def system
  end
  
  def ranking
  end
  
  def faqs
  end
  
  def terms
  end
  
  def privacy
  end
  
  def clinicians
  end

end
