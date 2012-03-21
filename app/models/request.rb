class Request < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :user
  
  default_scope :order => 'created_at DESC'
end
