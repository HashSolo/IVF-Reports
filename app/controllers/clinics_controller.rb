require 'csv'
require 'json'

class ClinicsController < ApplicationController
  before_filter :admin_user, 	:except => [:index, :show, :find_clinics_in_state, :pull_clinic_data]
  
  def index
    @title = "All Clinics"
  	@clinics = Clinic.paginate(:page => params[:page])
  	@all_clinics = Clinic.all
  	respond_to do |format|
  	  format.html {}
  	  format.json { render :json => @all_clinics.to_json() }
	  end
  end
  
  def pull_clinic_data
    @clinic = Clinic.find_by_id(params[:clinic_id])

    year = params[:year]
    diagnosis_group = params[:diagnosis]
    age_group = params[:age_group]
    
    if(age_group.nil?)
      @datapull = @clinic.datapoints.where(:year => year, :diagnosis => diagnosis_group)
    else
      @datapull = @clinic.datapoints.where(:year => year, :age_group => age_group)
    end
    respond_to do |format|
      format.json { render :json => @datapull.to_json() }
    end
  end
  
  def find_clinics_in_state
    @state = params[:state]
    @clinics = Clinic.where(:state => @state)
    respond_to do |format|
      format.json { render :json => @clinics.to_json() }
    end
  end
  
  def show
    year = params[:year]
    diagnosis = params[:diagnosis]
    age_group = params[:age_group]
    cycle_type = params[:cycle_type]
    
    if(year.nil?)
      year = '2009'
    else
      year = params[:year]
    end
    
    if(diagnosis.nil?)
      diagnosis = "All Diagnoses"
    else
      diagnosis = params[:diagnosis]
    end
    
    if(age_group.nil?)
      age_group = "All Ages"
    else
      age_group = params[:age_group]
    end
    
    if(cycle_type.nil?)
      cycle_type = "fresh"
    else
      cycle_type = params[:cycle_type]
    end

    @clinic = Clinic.find(params[:id])
    @datapoints = @clinic.datapoints.where(:year => year, :age_group => age_group, :diagnosis => diagnosis, :cycle_type => cycle_type)
    @scores = @clinic.scores.where(:year => year, :age_group => age_group, :diagnosis => diagnosis, :cycle_type => cycle_type)
    @scores_all_ages = @clinic.scores.where(:year => year, :age_group => "All Ages", :diagnosis => diagnosis, :cycle_type => cycle_type)
    @scores_35 = @clinic.scores.where(:year => year, :age_group => "<35", :diagnosis => diagnosis, :cycle_type => cycle_type)
    @scores_35_37 = @clinic.scores.where(:year => year, :age_group => "35-37", :diagnosis => diagnosis, :cycle_type => cycle_type)
    @scores_38_40 = @clinic.scores.where(:year => year, :age_group => "38-40", :diagnosis => diagnosis, :cycle_type => cycle_type)
    @scores_41_42 = @clinic.scores.where(:year => year, :age_group => "41-42", :diagnosis => diagnosis, :cycle_type => cycle_type)
    @scores_42 = @clinic.scores.where(:year => year, :age_group => ">42", :diagnosis => diagnosis, :cycle_type => cycle_type)
    @title = @clinic.clinic_name
  end
  
  def new
	  @title = "Add a New Clinic"
	  @clinic = Clinic.new
  end

  def create
	  @clinic = Clinic.new(params[:clinic])
	  if @clinic.save
	    flash[:success] = "Clinic successfully added."
	    redirect_to @clinic
	  else
	    @title = "Add a New Clinic"
	    render 'new'
	  end
  end

  def edit
	  @title = "Edit Clinic Info"
  end
  
  def update
	  @clinic = Clinic.find(params[:id])
	  if @clinic.update_attributes(params[:clinic])
	    flash[:success] = "Clinic Information Updated."
	    redirect_to @clinic
	  else
	    @title = "Edit Clinic Info"
	    render 'edit'
	  end
  end
  
  def destroy
	 	Clinic.find(params[:id]).destroy
		flash[:success] = "Clinic destroyed along with all associated data."
		redirect_to clinics_path
  end
  
  private
	
	  def admin_user
	    redirect_to(root_path) unless current_user.admin?
	  end
  
end
