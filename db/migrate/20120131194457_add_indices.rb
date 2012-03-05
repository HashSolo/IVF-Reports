class AddIndices < ActiveRecord::Migration
  def up
    add_index :datapoints, :clinic_id
    add_index :datapoints, :year
    add_index :datapoints, :diagnosis
    add_index :datapoints, :age_group
    add_index :scores, :clinic_id
    add_index :scores, :year
    add_index :scores, :diagnosis
    add_index :scores, :age_group
  end

  def down
    remove_index :datapoints, :clinic_id
    remove_index :datapoints, :year
    remove_index :datapoints, :diagnosis
    remove_index :datapoints, :age_group
    remove_index :scores, :clinic_id
    remove_index :scores, :year
    remove_index :scores, :diagnosis
    remove_index :scores, :age_group
  end
end
