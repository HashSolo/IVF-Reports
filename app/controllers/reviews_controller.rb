class ReviewsController < ApplicationController
  before_filter :authenticate, :except => :show
  def show
    
  end
  
  def create
    @review = Review.new(params[:review])
    @review.save
    @response = @review.errors
    @clinic = Clinic.find_by_id(params[:review][:clinic_id])
    flash[:success] = "Review Successfully Created!"
    redirect_to @clinic
  end
end
