class Score < ActiveRecord::Base
  belongs_to :clinic
  default_scope :order => 'ivf_reports_score DESC'
end
