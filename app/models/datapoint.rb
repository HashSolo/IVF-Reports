class Datapoint < ActiveRecord::Base
  belongs_to :clinic, :dependent => :destroy
end
