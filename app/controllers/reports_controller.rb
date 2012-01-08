class ReportsController < ApplicationController
  def the_ivf_process
  end
  
  def cdc_vs_sart
  end
  
  def fertility_news
  end
  
  def other_technologies
  end
  
  def clinics_by_region
  end
  
  def clinic_explorer
    #default diagnosis is all
    #default age group is <35
    #default year is 2009 (might not allow this to change)
    query_year = "2009";
    age = "<35";
    diagnosis = "All Diagnoses";
    cycles_lower = 0;
    cycles_upper = 25;
    avg_emb_trx_lower = 0;
    avg_emb_trx_upper = 7;
    imp_lower = 0;
    imp_upper = 100;
    preg_lower = 0;
    preg_upper = 100;
    birth_cycle_lower = 0;
    birth_cycle_upper = 100;
    birth_retrieval_lower = 0;
    birth_retrieval_upper = 100;
    birth_trx_lower = 100;
    birth_trx_upper = 100;
    set_lower = 0;
    set_upper = 100;
    cancellation_lower = 0;
    cancellation_upper = 100;
    twin_lower = 0;
    twin_upper = 100;
    trip_lower = 0;
    trip_upper = 100;
    if(params[:age].nil?)
      age = "<35"
    else
      age = params[:age]
    end
    
    if(params[:diagnosis].nil?)
      diagnosis = "All Diagnoses"
    else
      diagnosis = params[:diagnosis]
    end
    
    if(params[:cycles_lower].nil?)
      cycles_lower = 0
    else
      cycles_lower = params[:cycles_lower]
    end
    if(params[:cycles_upper].nil?)
      cycles_upper = 1500
    else
      cycles_upper = params[:cycles_upper]
    end
    
    if(params[:emb_trx_lower].nil?)
      avg_emb_trx_lower = 0
    else
      avg_emb_trx_lower = params[:emb_trx_lower]
    end
    if(params[:emb_trx_upper].nil?)
      avg_emb_trx_upper = 7
    else
      avg_emb_trx_upper = params[:emb_trx_upper]
    end
    
    
    if(params[:implantation_lower].nil?)
      imp_lower = 0
    else
      imp_lower = params[:implantation_lower]
    end
    if(params[:implantation_upper].nil?)
      imp_upper = 100
    else
      imp_upper = params[:implantation_upper]
    end
    
    if(params[:preg_lower].nil?)
      preg_lower = 0
    else
      preg_lower = params[:preg_lower]
    end
    if(params[:preg_upper].nil?)
      preg_upper = 100
    else
      preg_upper = params[:preg_upper]
    end
    
    if(params[:birth_cycle_lower].nil?)
      birth_cycle_lower = 0
    else
      birth_cycle_lower = params[:birth_cycle_lower]
    end
    if(params[:birth_cycle_upper].nil?)
      birth_cycle_upper = 100
    else
      birth_cycle_upper = params[:birth_cycle_upper]
    end
    
    if(params[:birth_retrieval_lower].nil?)
      birth_retrieval_lower = 0
    else
      birth_retrieval_lower = params[:birth_retrieval_lower]
    end
    if(params[:birth_retrieval_upper].nil?)
      birth_retrieval_upper = 100
    else
      birth_retrieval_upper = params[:birth_retrieval_upper]
    end
    
    if(params[:birth_trx_lower].nil?)
      birth_trx_lower = 0
    else
      birth_trx_lower = params[:birth_trx_lower]
    end
    if(params[:birth_trx_upper].nil?)
      birth_trx_upper = 100
    else
      birth_trx_upper = params[:birth_trx_upper]
    end
    
    if(params[:set_lower].nil?)
      set_lower = 0
    else
      set_lower = params[:set_lower]
    end
    if(params[:set_upper].nil?)
      set_upper = 100
    else
      set_upper = params[:set_upper]
    end
    
    if(params[:cancellation_lower].nil?)
      cancellation_lower = 0
    else
      cancellation_lower = params[:cancellation_lower]
    end
    if(params[:cancellation_upper].nil?)
      cancellation_upper = 100
    else
      cancellation_upper = params[:cancellation_upper]
    end
    
    if(params[:twin_lower].nil?)
      twin_lower = 0
    else
      twin_lower = params[:twin_lower]
    end
    if(params[:twin_upper].nil?)
      twin_upper = 100
    else
      twin_upper = params[:twin_upper]
    end
    
    if(params[:trip_lower].nil?)
      trip_lower = 0
    else
      trip_lower = params[:trip_lower]
    end
    if(params[:trip_upper].nil?)
      trip_upper = 100
    else
      trip_upper = params[:trip_upper]
    end
    
    
    @datapoints = Datapoint.where(:year => query_year, :age_group => age, :diagnosis => diagnosis, :cycles => (cycles_lower..cycles_upper), :avg_num_embs_transferred => (avg_emb_trx_lower..avg_emb_trx_upper), :implantation_rate => (imp_lower..imp_upper), :pregs_per_cycle => (preg_lower..preg_upper), :births_per_cycle => (birth_cycle_lower..birth_cycle_upper), :births_per_retrieval => (birth_retrieval_lower..birth_retrieval_upper), :births_per_transfer => (birth_trx_lower..birth_trx_upper), :set_transfer_rate => (set_lower..set_upper), :cancellation_rate => (cancellation_lower..cancellation_upper), :twin_rate => (twin_lower..twin_upper), :trip_rate => (trip_lower..trip_upper))
    
    @clinic_results = Array.new;
    @datapoints.each do |d|
      cur_clinic = Clinic.find_by_id(d.clinic_id)
      @clinic_results << cur_clinic
    end
    
    respond_to do |format|
  	  format.html {}
  	  format.json { render :json => @clinic_results.to_json() }
	  end
  end
end
