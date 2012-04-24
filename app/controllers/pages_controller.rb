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
  	year = "2010"
  	age = "All Ages"
  	diagnosis = "All Diagnoses"
  	cycle_type = "fresh"
    @states = State.all.collect { |state| state.name }
  	
  	respond_to do |format|
  	  format.html {}
  	  format.json do 
  	    @scores = Score.where(:year => year, :age_group => age, :diagnosis => diagnosis, :cycle_type => cycle_type).joins(:clinic).where(:clinics => {:state => @states})
        @clinic_results = Array.new;
        @scores.each do |s|
          cur_new_object = {'updated_at' => s.updated_at, 'year' => s.year, 'age_group' => s.age_group, 'diagnosis' => s.diagnosis, 'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => s.clinic.id, 'clinic_name' => s.clinic.clinic_name, 'permalink' => s.clinic.permalink, 'city' => s.clinic.city, 'state' => s.clinic.state, 'address' => s.clinic.address, 'practice_director' => s.clinic.practice_director, 'lab_director' => s.clinic.laboratory_director, 'medical_director' => s.clinic.medical_director, 'zip' => s.clinic.zip, 'info' => s.clinic.info, 'latitude' => s.clinic.latitude, 'longitude' => s.clinic.longitude}
          @clinic_results << cur_new_object
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
    year = '2010'
    age_group = 'All Ages'
    diagnosis = 'All Diagnoses'
    cycle_type = 'fresh'
    page = 0 #This is what page to start on
    @states = State.all

    
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
  
    states = params[:states]
    
    page=page.to_i
    
    results = 10 #The number of results per page    
    results_start = page*results    
    
    if params[:region]=="ALL"
      @scores = Score.where(:year => year, :age_group => age_group, :diagnosis => diagnosis, :cycle_type => cycle_type).joins(:clinic).where(:clinics => {:state => states}).limit(results).offset(results_start)
    else
      region = params[:region]
      @scores = Score.where(:year => year, :age_group => age_group, :diagnosis => diagnosis, :cycle_type => cycle_type).joins(:clinic).where(:clinics => {:state => states, :region => region}).limit(results).offset(results_start)
    end
    
    @clinic_results = Array.new;
    unless @scores.empty?
      @scores.each do |s|
        cur_new_object = {'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => s.clinic.id, 'clinic_name' => s.clinic.clinic_name, 'permalink' => s.clinic.permalink, 'city' => s.clinic.city, 'state' => s.clinic.state, 'address' => s.clinic.address, 'practice_director' => s.clinic.practice_director, 'lab_director' => s.clinic.laboratory_director, 'medical_director' => s.clinic.medical_director, 'zip' => s.clinic.zip}
        @clinic_results << cur_new_object
      end
    end
    
    respond_to do |format|
      format.html {}
      format.json {render :json => @clinic_results.to_json()}
    end
  end
  
  def faqs
    @title = "Frequently Asked Questions"
  end
  
  def terms
    @title = "Terms and Conditions"
  end
  
  def privacy
    @title = "Privacy Policy"
  end
  
  def clinicians
    @title = "Clinicians"
  end

end
