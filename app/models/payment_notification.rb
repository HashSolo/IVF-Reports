class PaymentNotification < ActiveRecord::Base
  belongs_to :request
  serialize :params
  after_create :mark_request_as_purchased
  
  private
    def mark_request_as_purchased
      if status == "Completed" && params[:secret]==APP_CONFIG[:paypal_secret]
        request.update_attributes(
          :purchased_at => Time.now,
          :visible => true
        )
      end
    end
end
