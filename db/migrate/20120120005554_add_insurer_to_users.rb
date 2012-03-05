class AddInsurerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :insurer, :boolean, :default => false
  end
end
