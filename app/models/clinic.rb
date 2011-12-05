class Clinic < ActiveRecord::Base
  has_many :datapoints
  
  def to_param
    "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end
end
