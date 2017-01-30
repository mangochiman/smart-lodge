ActionController::Routing::Routes.draw do |map|
  map.login  '/login',  :controller => 'users', :action => 'login'
  map.logout  '/logout',  :controller => 'users', :action => 'logout'
  map.new_user  '/new_user',  :controller => 'users', :action => 'new_user'
  map.view_users  '/view_users',  :controller => 'users', :action => 'view_users'
  map.void_users  '/void_users',  :controller => 'users', :action => 'void_users'
  map.authenticate  '/authenticate',  :controller => 'users', :action => 'authenticate'
  map.home  '/pages',  :controller => 'pages', :action => 'home'

  map.new_drug_menu  '/new_drug_menu',  :controller => 'pages', :action => 'new_drug_menu'
  map.edit_drug_menu  '/edit_drug_menu',  :controller => 'pages', :action => 'edit_drug_menu'
  map.view_drug_menu  '/view_drug_menu',  :controller => 'pages', :action => 'view_drug_menu'
  map.delete_drug_menu  '/delete_drug_menu',  :controller => 'pages', :action => 'delete_drug_menu'
  
  map.new_drug_menu  '/dashboard',  :controller => 'pages', :action => 'dashboard'
  map.settings_menu  '/settings_menu',  :controller => 'pages', :action => 'settings_menu'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "pages", :action => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
