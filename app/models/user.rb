class User < ActiveRecord::Base
  has_many :reviews
  has_many :requests
  has_many :clinics

	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation, :gender, :zip_code, :ethnicity, :birthday, :previous_cycles, :infertility_diagnosis, :abo_blood_type, :rh_factor, :height_ft, :height_inches, :weight, :day_3_fsh, :day_3_e2, :day_3_lh, :day_10_fsh, :day_10_e2, :day_10_lh, :prolactin, :uterine_fibroids, :uterine_tumors, :phone, :about
	
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	username_regex = /^[A-Za-z\d_]+$/
	
	validates :name,	:presence => true,
						        :length => { :maximum => 50 },
						        :format => { :with => username_regex },
						        :uniqueness => { :case_sensitive => false }
						
	validates :email,	:presence => true, 
						        :format => { :with => email_regex }, 
						        :uniqueness => { :case_sensitive => false }
						
	validates :password, 	:presence => true,
							          :confirmation => true,
							          :length => {:within => 6..40},
							          :on => :create
							          
	validates :password,  :confirmation => true,
	                      :on => :update
	
	
	before_save :encrypt_password, :unless => "password.blank?" || "confirmation.blank?"
  
	before_save :create_permalink
	
	def to_param
		permalink
	end
	
	
	#Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)#compare encrypted_password with the version in db
	end
	
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	
	private
	
		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
		
		def create_permalink
			self.permalink = name.downcase
		end
end
