class Request < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :user
end
