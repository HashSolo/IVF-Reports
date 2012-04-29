class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, 	:only => [:edit, :update]
  before_filter :admin_user, 	:only => :destroy
  
  def index
	  @title = "All Users"
	  @users = User.paginate(:page => params[:page])
  end
  
  def show
	  @user = User.find_by_permalink(params[:id])
	  
	  if @user.clinician?
	    redirect_to @user.clinics.first unless current_user?(@user)
    end
    
	  @title = @user.name
    
	  age_group = "All Ages"
	  diagnosis = "All Diagnoses"
	  cycle_type = "fresh"
	  year = "2010"

	  if(@user.birthday.nil?)
	    user_age = 0
    else
      user_age = ((Date.today) - (@user.birthday)).to_i/365
    end
    
    if(@user.infertility_diagnosis.nil?)
      diagnosis = "All Diagnoses"
	  elsif(@user.infertility_diagnosis=="endometriosis")
	    diagnosis = "Endometriosis"
	  elsif(@user.infertility_diagnosis=="diminished_ovarian_reserve")
	    diagnosis = "Diminished Ovarian Reserve"
	  elsif(@user.infertility_diagnosis=="multiple_female_factors")
	    diagnosis = "Multiple Female Factors"
	  elsif(@user.infertility_diagnosis=="ovulatory_dysfunction")
	    diagnosis = "Ovulatory Dysfunction"
	  elsif(@user.infertility_diagnosis=="tubal_factor")
	    diagnosis = "Tubal Factor"
	  elsif(@user.infertility_diagnosis=="female_and_male_factors")
	    diagnosis = "Female and Male Factors"
	  elsif(@user.infertility_diagnosis=="male_factor")
	    diagnosis = "Male Factor"
	  elsif(@user.infertility_diagnosis=="other_factor")
	    diagnosis = "Other Factor"
	  elsif(@user.infertility_diagnosis=="uterine_factor")
	    diagnosis = "Uterine Factor"
	  elsif(@user.infertility_diagnosis=="unknown_factor")
	    diagnosis = "Unknown Factor"
	  else
	    diagnosis = "All Diagnoses"
    end
	  
	  if(user_age < 35)
	    age_group = "<35"
    elsif(user_age >= 35 && user_age <= 37)
      age_group = "35-37"
    elsif(user_age >= 38 && user_age <= 40)
      age_group = "38-40"
    elsif(user_age >= 41 && user_age <= 42)
      age_group = "41-42"
    else
	    age_group = ">42"
	  end
	  
	  unless @user.zip_code.nil?
	    @coordinates = Geocoder.search(@user.zip_code)
    end
    
    if @coordinates.nil? || @coordinates.empty?
      @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).limit(5).offset(0)

  	  if(@scores.empty?)
  	    diagnosis = "All Diagnoses"
  	    @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).limit(5).offset(0)
      end
    else #If there is a zip code for the user and coordinates are produced
      lat_offset = 1.5
      long_offset = 1.5
      
      if @user.zip_distance=='25'
        lat_offset = 0.75
        long_offset = 0.75
      elsif @user.zip_distance=='50'
        lat_offset = 1.5
        long_offset = 1.5
      elsif @user.zip_distance=='100'
        lat_offset = 3.0
        long_offset = 3.0
      elsif @user.zip_distance=='200'
        lat_offset = 6.0
        long_offset = 6.0
      elsif @user.zip_distance=='ALL'
        lat_offset = 180.0
        long_offset = 180.0
      end
      
    	lat = @coordinates[0].latitude
    	low_lat = lat - lat_offset
    	high_lat = lat + lat_offset
    	long = @coordinates[0].longitude
    	low_long = long - long_offset
    	high_long = long + long_offset
      @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).joins(:clinic).where(:clinics => {:latitude => low_lat..high_lat, :longitude => low_long..high_long}).limit(5).offset(0)

  	  if(@scores.empty?)
  	    diagnosis = "All Diagnoses"
  	    @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).joins(:clinic).where(:clinics => {:latitude => low_lat..high_lat, :longitude => low_long..high_long}).limit(5).offset(0)
      end
  	end
	  

    
	  @clinic_results = Array.new;
    unless @scores.empty?
      @scores.each do |s|
        if(s.clinic_id==384)
          
        else
          cur_clinic = Clinic.find_by_id(s.clinic_id)
          cur_new_object = cur_new_object = {'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => cur_clinic.id, 'clinic_name' => cur_clinic.clinic_name, 'permalink' => cur_clinic.permalink, 'city' => cur_clinic.city, 'state' => cur_clinic.state, 'address' => cur_clinic.address, 'practice_director' => cur_clinic.practice_director, 'lab_director' => cur_clinic.laboratory_director, 'medical_director' => cur_clinic.medical_director, 'zip' => cur_clinic.zip}
          @clinic_results << cur_new_object
        end
      end
    end
  end

  def new
	  @title = "Sign Up"
	  @user = User.new
  end

  def create
	  @user = User.new(params[:user])
	  if @user.save
	    sign_in @user
	    flash[:success] = "Welcome to IVF Reports!"
	    

      email_body = "<img src='#{root_url}#{ActionController::Base.helpers.asset_path('logo.png')}'><br/>"
	    email_body += "<h1>Welcome to IVF Reports</h1>"
	    email_body += "<p>IVF Reports is the premier website for finding accurate information about U.S. Fertility Clinics. Our data specialists will help you find the best clinic <i>for you</i>.</p>"
	    email_body += "<p>Your Account Information:</p>"
	    email_body += "<ul><li><b>Username: </b>#{@user.username}</li>"
	    email_body += "<li><li><b>Email: </b> #{@user.email}</li></ul>"
	    email_body += "<p>#{ActionController::Base.helpers.link_to('Log in', signin_path)} to view personal recommendations for clinics best suited to treat you. You may contact up to five clinics through our system. Our relationships with Fertility Clinics will allow your case to receive high-level attention from a physician who can help you get pregnant.</p>"
      email_body += "<p>Thank you for being a part of our community. We look forward to helping you embark on your fertility journey.</p>"
      email_body += "<p>Warmest regards,</p>"
      email_body += "<p>The IVF Reports Team</p>"


      Pony.mail( 
      	:to => @user.email,
      	:subject => 'Welcome to IVF Reports.',
        :headers => { 'Content-Type' => 'text/html' },      	
      	:body => email_body
      )
	    
	    redirect_to @user
	  else
	    @title = "Sign Up"
	    render 'new'
	  end
  end

  def edit
	  @title = "Settings"
  end
  
  def update
	  @user = User.find_by_permalink(params[:id])
	  
    success = false
    
    unless params[:personal_info].nil?
      if @user.update_attributes(params[:personal_info])
        success = true
	    end
    end
	  
	  unless params[:medical_info].nil?
	    if @user.update_attributes(params[:medical_info])
        success = true
	    end
	  end

	  unless params[:account_info].nil?	  
	    if @user.update_attributes(params[:account_info])
        success = true
	    end
    end
	  
	  @response = @user.errors
	  
	  respond_to do |format|
	    format.html do |f| 
	        if @user.update_attributes(params[:user])
            flash[:success] = "Zip Code Radius Successfully Updated"
    	      redirect_to @user
  	      else
  	        flash[:error] = "There was an error processing your request."
  	        render 'show'
    	    end
      end
	    format.js {render :layout => false }
    end
  end
  
  def destroy
	  if current_user?(User.find_by_permalink(params[:id]))
		  flash[:notice] = "You cannot destroy yourself"
	  else
		  User.find_by_permalink(params[:id]).destroy
		  flash[:success] = "User destroyed."
	  end
	  respond_to do |format|
	    format.html
	    format.js
    end
  end
  
  private
	
	def correct_user
	  @user = User.find_by_permalink(params[:id])
	  redirect_to(root_path) unless current_user?(@user)
	end
	
	def admin_user
	  redirect_to(root_path) unless current_user.admin?
	end
	
	def insurance_user
	  redirect_to(root_path) unless current_user.insurer?
	end
end
