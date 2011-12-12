class PagesController < ApplicationController
  def home
  end

  def about
    @title = "About Us"
  end

  def contact
    @title = "Contact Us"
  end
  
  def clinicfind
    @title = "Find a Clinic"
  end
  
  def loadclinicdata
    
  end
  
  def system
  end
  
  def ranking
  end
  
  def faqs
  end
  
  def terms
  end
  
  def privacy
  end
  
  def clinicians
  end

end
