require 'csv'

namespace :db do
  desc "Add Optum Health Users."
  task :add_insurance_users => :environment do
	
	#create administrative user
	dlugi = User.create!(:name => "adlugi",
                         :email => "alexander.dlugi@optum.com",
                         :password => "optumhealth",
                         :password_confirmation => "optumhealth")
  dlugi.toggle!(:insurer)
	
	felix = User.create!(:name => "ffriedman",
                         :email => "felix.friedman@optum.com",
                         :password => "optumhealth",
                         :password_confirmation => "optumhealth")
  felix.toggle!(:insurer)
	
	
  end
end