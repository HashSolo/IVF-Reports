class Datapoint < ActiveRecord::Base
  belongs_to :clinic, :dependent => :destroy
  
  default_scope :order => 'implantation_rate DESC'
end
