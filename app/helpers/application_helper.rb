module ApplicationHelper
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
