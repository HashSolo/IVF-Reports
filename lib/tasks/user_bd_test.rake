require 'csv'

namespace :db do
  desc "Fill database with Chromosome data."
  task :user_bd_test => :environment do
	
	  @users = User.all
	  @users.each do |u|
	    unless u.birthday.nil?
	      age = (Date.today - u.birthday).to_i/365
        puts "#{u.name} is #{age} years old."	      
	    end
    end
	
  end
end