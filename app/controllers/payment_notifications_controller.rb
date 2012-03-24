class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    PaymentNotification.create!(:params => params, :request_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:transaction_id])
    render :nothing => true
    end
  end
end
