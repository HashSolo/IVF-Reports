class StatisticsController < ApplicationController
  before_filter :correct_user, :index

  def index
    @clinic = Clinic.find_by_id(params[:clinic_id])
    @title = "#{@clinic.clinic_name} | Reports"
    national_data_id = 384
    clinic_id = @clinic.id
    age_group = "<35"
    year = "2010"
    diagnosis = "All Diagnoses"
    statistic_visualize = "implantation_rate"
    compare_across = "age_group"
    
    unless(params[:statistic_across].nil?)
      compare_across = params[:statistic_across]
    end
    
    unless(params[:clinic_id].nil?)
      clinic_a_id = params[:clinic_id]
    end
    
    unless(params[:age_group].nil?)
      age_group = params[:age_group]
    end
    
    unless(params[:year].nil?)
      year = params[:year]
    end
    
    unless(params[:diagnosis].nil?)
      diagnosis = params[:diagnosis]
    end
    
    unless(params[:statistic_visualize].nil?)
      statistic_visualize = params[:statistic_visualize]
    end
    
    @clinic_query = Clinic.find_all_by_id([clinic_id, national_data_id])

    @clinic_results = Array.new;  
      
    @clinic_query.each do |clin|
      @datapull = []
      
      if(compare_across=="age_group")
        @datapull = clin.datapoints.where(:year => year, :diagnosis => diagnosis)
      elsif(compare_across=="year")
        @datapull = clin.datapoints.where(:diagnosis => diagnosis, :age_group => age_group)
      elsif(compare_across=="diagnosis")
        @datapull = clin.datapoints.where(:year => year, :age_group => age_group)
      end      

      @datapull.each do |d|
        cur_clinic = Clinic.find_by_id(d.clinic_id)
        cur_new_object = {'clinic_id' => cur_clinic.id, 'clinic_name' => cur_clinic.clinic_name, 'permalink' => cur_clinic.permalink, 'city' => cur_clinic.city, 'state' => cur_clinic.state, 'address' => cur_clinic.address, 'practice_director' => cur_clinic.practice_director, 'lab_director' => cur_clinic.laboratory_director, 'medical_director' => cur_clinic.medical_director, 'zip' => cur_clinic.zip, 'updated_at' => d.updated_at, 'year' => d.year, 'age_group' => d.age_group, 'diagnosis' => d.diagnosis, 'statistic_visualize' => d[statistic_visualize], 'implantation_rate' => d.implantation_rate, 'pregnancy_rate' => d.pregs_per_cycle, 'birth_cycle_rate' => d.births_per_cycle, 'birth_retrieval_rate' => d.births_per_retrieval, 'birth_transfer_rate' => d.births_per_transfer, 'set_transfer_rate' => d.set_transfer_rate, 'cancellation_rate' => d.cancellation_rate, 'twin_rate' => d.twin_rate, 'trip_rate' => d.trip_rate, 'cycles' => d.cycles, 'avg_num_embs_transferred' => d.avg_num_embs_transferred }
        @clinic_results << cur_new_object
      end
    end
    
    respond_to do |format|
      format.html {}
      format.json { render :json => @clinic_results.to_json() }
    end
  end
  
  private
    def admin_user
	    redirect_to(root_path) unless current_user.admin?
	  end
		  
    def correct_user
      @clinic = Clinic.find(params[:clinic_id])      
      if signed_in?
        if current_user.admin?
        elsif current_user.clinician? #Only clinician users can see the statistics page
          if @clinic.user_id.nil? #The clinic has not been claimed
            redirect_to(@clinic)
          else
            @clinic_user = User.find_by_id(@clinic.user_id) #The clinic users can only see their own clinic's statistics.
            redirect_to(@clinic) unless current_user?(@clinic_user)
          end
        else
          redirect_to(@clinic)
    	  end
  	  else
  	    redirect_to(@clinic)
	    end
    end
    
end
