class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.integer :clinic_id
      t.boolean :visible, :default => false

      t.timestamps
    end
  end
end
