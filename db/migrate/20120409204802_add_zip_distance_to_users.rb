class AddZipDistanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip_distance, :string, :default => '50'
  end
end
