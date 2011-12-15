require 'csv'

namespace :db do
  desc "Fill database with Chromosome data."
  task :admin_data => :environment do
	
	#create administrative user
	admin = User.create!(:name => "alexbiz",
                         :email => "alex@alx.bz",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin)
	
	
  end
end