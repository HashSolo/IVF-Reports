class StatisticsController < ApplicationController
  before_filter :correct_user

  def index
    @clinic = Clinic.find_by_id(params[:clinic_id])
    @title = "Statistics"
  end
  
  private
    def admin_user
	    redirect_to(root_path) unless current_user.admin?
	  end
		  
    def correct_user
      if current_user.admin?
      elsif current_user.clinician? #Only clinician users can see the statistics page
        @clinic = Clinic.find(params[:id])
        if @clinic.user_id.nil? #The clinic has not been claimed
          redirect_to(@clinic)
        else
          @clinic_user = User.find_by_id(@clinic.user_id) #The clinic users can only see their own clinic's statistics.
          redirect_to(root_path) unless current_user?(@clinic_user)
        end
  	  end
    end
    
end
