require 'csv'
require 'json'

class ClinicsController < ApplicationController
  before_filter :admin_user, 	:except => [:index, :show, :find_clinics_in_state, :pull_clinic_data]
  
  def index
    @title = "All Clinics"
  	@clinics = Clinic.paginate(:page => params[:page])
  	@all_clinics = Clinic.all
  	@states = State.all
  	respond_to do |format|
  	  format.html {}
  	  format.json { render :json => @all_clinics.to_json() }
	  end
  end
  
  def pull_clinic_data    
    @clinic = Clinic.find_by_id(params[:clinic_id])

    year = params[:year]
    diagnosis_group = params[:diagnosis]
    
    @datapull = @clinic.datapoints.where(:year => year, :diagnosis => diagnosis_group)
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
    @clinic = Clinic.find(params[:id])
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
