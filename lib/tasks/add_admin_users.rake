require 'csv'

namespace :db do
  desc "Fill database with Chromosome data."
  task :add_admin_users => :environment do
	
	  #create administrative user
	  admin = User.create!(:name => "alexbiz",
                         :email => "alex@alx.bz",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin)
	
	
  end
end