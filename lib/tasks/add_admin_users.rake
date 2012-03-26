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
    
    #create administrative user
  	admin2 = User.create!(:name => "chriscleveland",
                           :email => "cfclevel@gmail.com",
                           :password => "foobar",
                           :password_confirmation => "foobar")
    admin2.toggle!(:admin)
      
    admin3 = User.create!(  :name => "ivfreports",
                            :email => 'info@ivfreports.org',
                            :password => "foobar",
                            :password_confirmation => "foobar"
    )
	
	
  end
end