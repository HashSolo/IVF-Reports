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
  	year = "2009"
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
    @title = "IVF Clinic Rankings"
    year = '2009'
    age_group = 'All Ages'
    diagnosis = 'All Diagnoses'
    cycle_type = 'fresh'
    page = 0 #This is what page to start on


    
    unless(params[:year].nil?)
      year = params[:year]
    end
    unless(params[:age_group].nil?)
      age_group = params[:age_group]
    end
    unless(params[:diagnosis].nil?)
      diagnosis = params[:diagnosis]
    end
    unless(params[:cycle_type].nil?)
      cycle_type = params[:cycle_type]
    end
    unless(params[:page].nil?)
      page = params[:page]
    end
    
    page=page.to_i
    
    results = 10 #The number of results per page    
    results_start = page*results    
    
    @scores = Score.where(:year => year, :age_group => age_group, :diagnosis => diagnosis, :cycle_type => cycle_type).limit(results).offset(results_start)
    @clinic_results = Array.new;
    unless @scores.empty?
      @scores.each do |s|
        cur_clinic = Clinic.find_by_id(s.clinic_id)
        cur_new_object = cur_new_object = {'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => cur_clinic.id, 'clinic_name' => cur_clinic.clinic_name, 'permalink' => cur_clinic.permalink, 'city' => cur_clinic.city, 'state' => cur_clinic.state, 'address' => cur_clinic.address, 'practice_director' => cur_clinic.practice_director, 'lab_director' => cur_clinic.laboratory_director, 'medical_director' => cur_clinic.medical_director, 'zip' => cur_clinic.zip}
        @clinic_results << cur_new_object
      end
    end
    
    respond_to do |format|
      format.html {}
      format.json {render :json => @clinic_results.to_json()}
    end
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
