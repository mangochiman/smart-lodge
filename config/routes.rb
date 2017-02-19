ActionController::Routing::Routes.draw do |map|
  map.login  '/login',  :controller => 'users', :action => 'login'
  map.logout  '/logout',  :controller => 'users', :action => 'logout'
  map.new_user  '/new_user',  :controller => 'users', :action => 'new_user'
  map.view_users  '/view_users',  :controller => 'users', :action => 'view_users'
  map.void_users  '/void_users',  :controller => 'users', :action => 'void_users'
  map.authenticate  '/authenticate',  :controller => 'users', :action => 'authenticate'
  map.home  '/pages',  :controller => 'pages', :action => 'home'

  map.new_room_type_menu  '/new_room_type_menu',  :controller => 'admin', :action => 'new_room_type_menu'
  map.edit_room_types_menu  '/edit_room_types_menu',  :controller => 'admin', :action => 'edit_room_types_menu'
  map.edit_room_type '/edit_room_type/:room_type_id', :controller => 'admin', :action => 'edit_room_type'
  map.view_room_types_menu  '/view_room_types_menu',  :controller => 'admin', :action => 'view_room_types_menu'
  map.remove_room_types_menu  '/remove_room_types_menu',  :controller => 'admin', :action => 'remove_room_types_menu'

  map.new_rooms_menu  '/new_rooms_menu',  :controller => 'admin', :action => 'new_rooms_menu'
  map.edit_rooms_menu  '/edit_rooms_menu',  :controller => 'admin', :action => 'edit_rooms_menu'
  map.edit_room '/edit_room/:room_id', :controller => 'admin', :action => 'edit_room'
  map.view_rooms_menu  '/view_rooms_menu',  :controller => 'admin', :action => 'view_rooms_menu'
  map.remove_rooms_menu  '/remove_rooms_menu',  :controller => 'admin', :action => 'remove_rooms_menu'

  map.new_rates_menu  '/new_rates_menu',  :controller => 'admin', :action => 'new_rates_menu'
  map.edit_rates_menu  '/edit_rates_menu',  :controller => 'admin', :action => 'edit_rates_menu'
  map.edit_room_rate '/edit_room_rate/:room_rate_id', :controller => 'admin', :action => 'edit_room_rate'
  map.view_rates_menu  '/view_rates_menu',  :controller => 'admin', :action => 'view_rates_menu'
  map.remove_rates_menu  '/remove_rates_menu',  :controller => 'admin', :action => 'remove_rates_menu'


  map.new_rooms_menu  '/new_users_menu',  :controller => 'admin', :action => 'new_users_menu'
  map.edit_rooms_menu  '/edit_users_menu',  :controller => 'admin', :action => 'edit_users_menu'
  map.edit_user '/edit_user/:user_id', :controller => 'admin', :action => 'edit_user'
  map.view_rooms_menu  '/view_users_menu',  :controller => 'admin', :action => 'view_users_menu'
  map.remove_rooms_menu  '/remove_users_menu',  :controller => 'admin', :action => 'remove_users_menu'


  map.my_account  '/my_account',  :controller => 'admin', :action => 'my_account'
  map.admin_dashboard  '/admin_dashboard',  :controller => 'admin', :action => 'dashboard'
  map.settings_menu  '/settings_menu',  :controller => 'pages', :action => 'settings_menu'

  #########GUESTS START ########################################################################
  map.guests  '/guests',  :controller => 'pages', :action => 'guests'
  map.check_in_menu  '/check_in_menu',  :controller => 'pages', :action => 'check_in_menu'
  map.check_out_menu  '/check_out_menu',  :controller => 'pages', :action => 'check_out_menu'
  map.invoices_menu  '/invoices_menu',  :controller => 'pages', :action => 'invoices_menu'

  map.new_payment_menu  '/new_payment_menu',  :controller => 'pages', :action => 'new_payment_menu'
  map.view_payments_menu  '/view_payments_menu',  :controller => 'pages', :action => 'view_payments_menu'
  #map.search_results  '/search_results',  :controller => 'pages', :action => 'search_results'
  #########GUESTS END########################################################################
  
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
