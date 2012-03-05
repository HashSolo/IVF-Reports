class AddUserIdToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :user_id, :integer
  end
end
