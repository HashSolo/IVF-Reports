module ApplicationHelper
  def user_clinic
    if signed_in? && current_user.clinician?
      return current_user.clinics.first
    end
  end
  
  def title
		base_title = "IVF Reports"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
	
	def logo
		logo_path = image_tag("logo.png", :alt => "Sample App", :class => "round")
	end
end
