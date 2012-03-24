class Request < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :user
  
  default_scope :order => 'created_at DESC'
  
  
  #can add a method that calculates the price
  
  def paypal_url(return_url, notify_url)
    user = User.find_by_id(user_id)
    
    values = {
      :business => 'info@ivfreports.org',
      :cmd => "_xclick",
      :lc => 'US',
      :item_name => "Patient Lead: #{user.name}",
      :item_number => id,
      :invoice => id,
      :amount => 100.00,
      :currency_code => 'USD',
      :notify_url => notify_url,
      :return => return_url
    }
    values.merge!({
      "amount_1" => 100.00,
      "item_name_1" => user.name,
      "item_number_1" => id
    })
    
    "http://www.paypal.com/cgi-bin/webscr?"+values.to_query
    
  end
end
