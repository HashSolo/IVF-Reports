class AddAboutToUsers < ActiveRecord::Migration
  def up
    add_column :users, :about_me, :text
    add_column :users, :user_type, :string
  end
  
  def down
    remove_column :users, :about_me
    remove_column :users, :user_type, :string
  end
end
