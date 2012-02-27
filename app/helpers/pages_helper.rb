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
	
	def is_controller?(controller)
	  page_controller = params[:controller]
	  if(page_controller==controller)
	    return true
    else
      return false
    end
	end
	
	def is_action?(action)
	  page_action = params[:action]
	  if(page_action==action)
	    return true
    else
      return false
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
	
	def is_clinic_explorer?()
	  page_action = params[:action]
	  page_controller = params[:controller]
	  if(page_action=="clinic_explorer" && page_controller=="reports")
	    return true
    else
    end
  end
	
	def is_clinic_comparator?()
	  page_action = params[:action]
	  page_controller = params[:controller]
	  if(page_action=="clinic_comparator" && page_controller=="reports")
	    return true
    else
    end
  end
	
end
