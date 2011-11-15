module PagesHelper
  def is_active?(page_name)
		pageaction = params[:action]
		pagecontroller = params[:controller]
		actionandcontroller = pagecontroller + "#" + pageaction
		if actionandcontroller == page_name
			"active"
		else
			""
		end
	end
end
