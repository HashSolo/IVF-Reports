require 'csv'
require 'json'

class ReportsController < ApplicationController
  before_filter :authenticate, :only => [:clinic_explorer, :clinic_comparator]
  before_filter :admin_or_insurance_user, 	:only => [:clinic_explorer, :clinic_comparator]
  
  def the_ivf_process
    @title = "The IVF Process"
  end
  
  def infertility_diagnoses
    @title = "Infertility Diagnoses"
  end
  
  def cdc_vs_sart
    @title = "The CDC vs. SART"
  end
  
  def fertility_news
    @title = "Fertility News"
  end
  
  def other_technologies
  end
  
  def clinic_comparator
    @title = "Clinic Comparator"
    @clinics = Clinic.all
    national_data_id = 384
    clinic_a_id = 384
    clinic_b_id = 384
    age_group = "<35"
    year = "2010"
    diagnosis = "All Diagnoses"
    statistic_visualize = "implantation_rate"
    compare_across = "age_group"
    
    unless(params[:statistic_across].nil?)
      compare_across = params[:statistic_across]
    end
    
    unless(params[:clinic_a_id].nil?)
      clinic_a_id = params[:clinic_a_id]
    end
    
    unless(params[:clinic_b_id].nil?)
      clinic_b_id = params[:clinic_b_id]
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
    
    @clinic_query = Clinic.find_all_by_id([clinic_a_id, clinic_b_id, national_data_id])

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
  
  
  def clinic_explorer
    @title = "Clinic Explorer"
    #default diagnosis is all
    #default age group is <35
    #default year is 2009 (might not allow this to change)
    query_year = "2010"
    age = "<35"
    diagnosis = "All Diagnoses"
    cycles_lower = 0
    cycles_upper = 25
    avg_emb_trx_lower = 0
    avg_emb_trx_upper = 7
    imp_lower = 0
    imp_upper = 100
    preg_lower = 0
    preg_upper = 100
    birth_cycle_lower = 0
    birth_cycle_upper = 100
    birth_retrieval_lower = 0
    birth_retrieval_upper = 100
    birth_trx_lower = 100
    birth_trx_upper = 100
    set_lower = 0
    set_upper = 100
    cancellation_lower = 0
    cancellation_upper = 100
    twin_lower = 0
    twin_upper = 100
    trip_lower = 0
    trip_upper = 100
    if(params[:year].nil?)
      query_year = "2009"
    else
      query_year = params[:year]
    end
    
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
      if(d.clinic_id==384)
        
      else
        cur_clinic = Clinic.find_by_id(d.clinic_id)
        cur_new_object = {'updated_at' => d.updated_at, 'year' => d.year, 'age_group' => d.age_group, 'diagnosis' => d.diagnosis, 'implantation_rate' => d.implantation_rate, 'pregnancy_rate' => d.pregs_per_cycle, 'birth_cycle_rate' => d.births_per_cycle, 'birth_retrieval_rate' => d.births_per_retrieval, 'birth_transfer_rate' => d.births_per_transfer, 'set_transfer_rate' => d.set_transfer_rate, 'cancellation_rate' => d.cancellation_rate, 'twin_rate' => d.twin_rate, 'trip_rate' => d.trip_rate, 'cycles' => d.cycles, 'avg_num_embs_transferred' => d.avg_num_embs_transferred, 'clinic_id' => cur_clinic.id, 'clinic_name' => cur_clinic.clinic_name, 'permalink' => cur_clinic.permalink, 'city' => cur_clinic.city, 'state' => cur_clinic.state, 'address' => cur_clinic.address, 'practice_director' => cur_clinic.practice_director, 'lab_director' => cur_clinic.laboratory_director, 'medical_director' => cur_clinic.medical_director, 'zip' => cur_clinic.zip}
        @clinic_results << cur_new_object
      end
    end
    

    
    respond_to do |format|
  	  format.html {}
  	  format.json { render :json => @clinic_results.to_json() }
  	  format.csv { download_csv(@clinic_results) }
	  end
  end
  
end
