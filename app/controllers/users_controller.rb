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
	  @title = @user.name.capitalize
	  
	  age_group = "All Ages"
	  diagnosis = "All Diagnoses"
	  cycle_type = "fresh"
	  year = "2009"

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
	  
	  @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).limit(5).offset(0)
	  
	  if(@scores.empty?)
	    diagnosis = "All Diagnoses"
	    @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).limit(5).offset(0)
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
	    format.html {}
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
