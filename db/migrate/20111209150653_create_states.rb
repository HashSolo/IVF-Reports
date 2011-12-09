class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :abbrev
      t.string :name
      t.integer :population
      t.string :capital
      t.timestamps
    end
  end
end
