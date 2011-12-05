module PagesHelper
  def is_active?(page_name)
		pageaction = params[:action]
		pagecontroller = params[:controller]
		actionandcontroller = pagecontroller + "#" + pageaction
		if actionandcontroller == page_name
			"selected"
		else
			""
		end
	end
	
	def is_clinic_index?()
	  page_action = params[:action]
	  page_controller = params[:controller]
	  if(page_action=="index" && page_controller=="clinics")
	    return true
    else
    end
	end
	
end
