class AddPurchasedAttoRequests < ActiveRecord::Migration
  def up
    add_column :requests, :purchased_at, :timestamp
  end

  def down
    remove_column :requests, :purchased_at
  end
end
