class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :clinic
  
  default_scope :order => 'created_at DESC'
end
