Transit::Application.routes.draw do
  resources :users
	resources :sessions, :only => [:new, :create, :destroy]
	resources :clinics do
	  get 'find_clinics_in_state', :on => :collection
	  resources :datapoints
  end
	
	
	resources :datapoints
	match '/register', :to => 'users#new'
	match '/signin', :to => 'sessions#new'
	match '/signout', :to => 'sessions#destroy'

  root :to => "pages#home"
  
  match "/find-a-clinic", :to => "pages#clinicfind"
  match "/ranking", :to => "pages#ranking"
  match "/our-system", :to => "pages#system"
  match "/faqs", :to => "pages#faqs"
  match "/about", :to => "pages#about"
  match "/contact", :to => "pages#contact"
  match "/terms-and-conditions", :to => "pages#terms"
  match "/privacy-policy", :to => "pages#privacy"
  match "/clinicians", :to => "pages#clinicians"
  
  match "/reports/the-ivf-process", :to => "reports#the_ivf_process"
  match "/reports/cdc-vs-sart", :to => "reports#cdc_vs_sart"
  match "/reports/fertility-news", :to => "reports#fertility_news"
  match "/reports/other-technologies", :to => "reports#other_technologies"
  match "/reports/clinics-by-region", :to => "reports#clinics_by_region"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
