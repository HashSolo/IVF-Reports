class Clinic < ActiveRecord::Base
  has_many :datapoints
  has_many :scores
  has_many :reviews
  
  default_scope :order => 'state ASC'
  
  def to_param
    "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end
  
  
	before_save :create_permalink
  
  private
		def create_permalink
			self.permalink = "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
		end
end
