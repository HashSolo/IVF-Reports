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
	
	def send_welcome_email(user)
    email_body = "<h1>Welcome to IVF Reports</h1>"
    email_body += "#{image_tag('logo.png')}"
    
    Pony.mail( 
    	:to => user.email,
    	:subject => 'Welcome to IVF Reports.',
    	:body => email_body
    )
  end
end
