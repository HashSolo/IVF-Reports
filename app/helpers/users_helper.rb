module UsersHelper

	def gravatar_for(user, options = { :size => 50 })
		gravatar_image_tag(user.email.downcase,	:alt => user.name,
												:class => 'gravatar',
												:gravatar => options)
	end
	
	def large_gravatar_for(user, options = {:size => 150})
	  gravatar_image_tag(user.email.downcase,	:alt => user.name,
	                      :style => 'display:block;margin-left:auto;margin-right:auto;',
												:class => 'large_gravatar',
												:gravatar => options)
	end
	
	def contacts_remaining(user)
	  outstanding_contacts = user.requests.where(:declined => false)
	  remaining = (5 - outstanding_contacts.count)
  end
end
