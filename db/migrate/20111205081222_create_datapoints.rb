class CreateDatapoints < ActiveRecord::Migration
  def change
    create_table :datapoints do |t|
        t.integer :clinic_id
        t.string :age_group
        t.string :year
        t.string :diagnosis
        t.string :cycle_type
        t.integer :cycles
        t.float :implantation_rate
        t.float :avg_num_embs_transferred
        t.float :birth_rate
        t.float :pregs_per_cycle
        t.float :births_per_cycle
        t.float :births_per_retrieval
        t.float :births_per_transfer
        t.float :set_transfer_rate
        t.float :cancellation_rate
        t.float :twin_rate
        t.float :trip_rate
        t.float :procedure_ivf_rate
        t.float :procedure_gift_rate
        t.float :procedure_zift_rate
        t.float :procedure_icsi_rate
        t.float :procedure_unstimulated_rate
        t.float :procedure_pgd_rate
      t.timestamps
    end
  end
end
