class RemoveBirthRateFromDatapoint < ActiveRecord::Migration
  def up
    remove_column :datapoints, :birth_rate
  end

  def down
    add_column :datapoints, :birthrate
  end
end
