class AddPermalinkToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :permalink, :string
  end
end
