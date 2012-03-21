class RequestsController < ApplicationController
  before_filter :authenticate, :only => [:index, :show, :purchase, :create]
  before_filter :correct_user, :only => [:index, :show, :purchase]
  before_filter :clinic_or_admin_user, :only => :show
  
  def index #Clinics can see all requests made to them and opt to purchase them here. Admins can see all requests.
    if params[:clinic_id].nil? && params[:user_id].nil? && current_user.admin? #Only the admins can see the full request index
      @title = "All Leads"
      @requests = Request.all
    elsif !params[:clinic_id].nil?
      @clinic = Clinic.find(params[:clinic_id])
      @requests = @clinic.requests
      @title = "Leads for #{@clinic.clinic_name}"
    elsif !params[:user_id].nil?
      @user = User.find_by_permalink(params[:user_id])
      @requests = @user.requests
      @title = "Clinics You Have Contacted"
    end
  end
  
  def show #This will provide a more in depth summary about the use/patient who has made the contact request.
    if params[:clinic_id].nil? && current_user.admin?
      @request = Request.find(params[:id])
      @request_user = User.find(@request.user_id)
    else
      @clinic = Clinic.find(params[:clinic_id])
      @request = Request.find(params[:id])
      @request_user = User.find(@request.user_id)
    end
    
    respond_to do |format|
      format.html {}
    end
  end
  
  def test
    @request = Request.where(:clinic_id => params[:clinic_id], :user_id => params[:user_id])
    
    respond_to do |format|
      format.json {render :json => @request.to_json()}
    end    
  end
  
  def purchase #This will be the method for purchasing the lead after reviewing the information
    
  end
  
  def create
    if(params[:request].nil?)
      params[:request] = {:user_id => params[:user_id], :clinic_id => params[:clinic_id]}
    end
    @clinic = Clinic.find(params[:request][:clinic_id])
    if Request.where(:clinic_id => params[:request][:clinic_id], :user_id => params[:request][:user_id]).empty?
      @request = Request.new(params[:request])
      @request.save
	    @response = @request.errors
    end
    respond_to do |format|
      format.js {render :layout => false}
    end
  end
  
  private
    def correct_user #It has to be the patient, the clinic the patient belongs to, or an admin
      if current_user.admin?
      elsif current_user.clinician?
        @clinic = Clinic.find(params[:clinic_id])
        if @clinic.user_id.nil? #The clinic has not been claimed
          redirect_to(@clinic)
        else
          @clinic_user = User.find(@clinic.user_id)
  	      redirect_to(@clinic) unless current_user?(@clinic_user)
	      end
	    else
	      @current_user = User.find_by_permalink(params[:user_id])
	      redirect_to(@current_user) unless current_user?(@current_user)
	    end
  	end
  	
  	def clinic_or_admin_user
      unless current_user.admin? || current_user.clinician?
        @user = User.find_by_permalink(params[:user_id])
      end
  	  redirect_to([@user, :requests]) unless current_user.admin? || current_user.clinician?
	  end
end


