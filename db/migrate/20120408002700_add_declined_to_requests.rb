class AddDeclinedToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :declined, :boolean, :default => false
  end
end
