class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :clinic_id
      t.string :year
      t.string :age_group
      t.string :diagnosis
      t.string :cycle_type
      t.float :ivf_reports_score
      t.float :quality_score
      t.float :safety_score
      t.float :sart_score

      t.timestamps
    end
  end
end
