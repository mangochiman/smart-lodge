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

  map.new_taxes_menu  '/new_taxes_menu',  :controller => 'admin', :action => 'new_taxes_menu'
  map.edit_taxes_menu  '/edit_taxes_menu',  :controller => 'admin', :action => 'edit_taxes_menu'
  map.edit_tax '/edit_tax/:tax_id', :controller => 'admin', :action => 'edit_tax'
  map.view_taxes_menu '/view_taxes_menu/', :controller => 'admin', :action => 'view_taxes_menu'
  map.remove_taxes_menu  '/remove_taxes_menu',  :controller => 'admin', :action => 'remove_taxes_menu'

  map.new_rooms_menu  '/new_users_menu',  :controller => 'admin', :action => 'new_users_menu'
  map.edit_rooms_menu  '/edit_users_menu',  :controller => 'admin', :action => 'edit_users_menu'
  map.edit_user '/edit_user/:user_id', :controller => 'admin', :action => 'edit_user'
  map.view_rooms_menu  '/view_users_menu',  :controller => 'admin', :action => 'view_users_menu'
  map.remove_rooms_menu  '/remove_users_menu',  :controller => 'admin', :action => 'remove_users_menu'

  map.new_black_list_menu  '/new_black_list_menu',  :controller => 'pages', :action => 'new_black_list_menu'
  map.view_black_list_menu  '/view_black_list_menu',  :controller => 'pages', :action => 'view_black_list_menu'
  map.delete_black_list_menu  '/delete_black_list_menu',  :controller => 'pages', :action => 'delete_black_list_menu'

  map.my_account  '/my_account',  :controller => 'admin', :action => 'my_account' #my_account_guests
  map.my_account_guests  '/my_account_guests',  :controller => 'pages', :action => 'my_account_guests'
  map.admin_dashboard  '/admin_dashboard',  :controller => 'admin', :action => 'dashboard'
  map.settings_menu  '/settings_menu',  :controller => 'pages', :action => 'settings_menu'
  map.view_all_check_ins_menu  '/view_all_check_ins_menu',  :controller => 'pages', :action => 'view_all_check_ins_menu'
  map.view_all_check_outs_menu  '/view_all_check_outs_menu',  :controller => 'pages', :action => 'view_all_check_outs_menu'
  #########GUESTS START ########################################################################
  map.guests  '/guests',  :controller => 'pages', :action => 'guests'
  map.check_in_menu  '/check_in_menu',  :controller => 'pages', :action => 'check_in_menu'
  map.check_out_menu  '/check_out_menu',  :controller => 'pages', :action => 'check_out_menu'
  map.adjust_booking_menu  '/adjust_booking_menu',  :controller => 'pages', :action => 'adjust_booking_menu'
  map.cancel_client_checkout  '/cancel_client_checkout',  :controller => 'pages', :action => 'cancel_client_checkout'
  map.cancel_client_booking  '/cancel_client_booking',  :controller => 'pages', :action => 'cancel_client_booking'
  map.process_checkout  '/process_checkout',  :controller => 'pages', :action => 'process_checkout'
  map.check_out_client  '/check_out_client',  :controller => 'pages', :action => 'check_out_client'
  map.invoices_menu  '/invoices_menu',  :controller => 'pages', :action => 'invoices_menu'
  map.view_invoice  '/view_invoice',  :controller => 'pages', :action => 'view_invoice'
  map.new_invoice  '/new_invoice',  :controller => 'pages', :action => 'new_invoice'

  map.new_payment_menu  '/new_payment_menu',  :controller => 'pages', :action => 'new_payment_menu'
  map.view_payments_menu  '/view_payments_menu',  :controller => 'pages', :action => 'view_payments_menu'


  map.view_customers_menu  '/view_customers_menu',  :controller => 'pages', :action => 'view_customers_menu'
  map.edit_personal_details  '/edit_personal_details',  :controller => 'pages', :action => 'edit_personal_details'
  map.personal_booking_details  '/personal_booking_details',  :controller => 'pages', :action => 'personal_booking_details'
  map.report_menu  '/report_menu',  :controller => 'pages', :action => 'report_menu'
  map.bookings_by_gender_report_menu  '/bookings_by_gender_report_menu',  :controller => 'pages', :action => 'bookings_by_gender_report_menu'
  map.bookings_by_custom_date_report_menu  '/bookings_by_custom_date_report_menu',  :controller => 'pages', :action => 'bookings_by_custom_date_report_menu'
  map.bookings_by_room_report_menu  '/bookings_by_room_report_menu',  :controller => 'pages', :action => 'bookings_by_room_report_menu'
  map.make_payment  '/make_payment',  :controller => 'pages', :action => 'make_payment'
  map.search_rooms  '/search_rooms',  :controller => 'pages', :action => 'search_rooms'
  map.checkout_report_menu  '/checkout_report_menu',  :controller => 'pages', :action => 'checkout_report_menu'
  map.payments_report_menu  '/payments_report_menu',  :controller => 'pages', :action => 'payments_report_menu'
  map.black_list_report_menu  '/black_list_report_menu',  :controller => 'pages', :action => 'black_list_report_menu'
  #map.search_results  '/search_results',  :controller => 'pages', :action => 'search_results'

  map.view_invoice_plain  '/view_invoice_plain',  :controller => 'print', :action => 'view_invoice_plain'
  map.print_invoice  '/print_invoice',  :controller => 'print', :action => 'print_invoice'
  map.download_invoice  '/download_invoice',  :controller => 'print', :action => 'download_invoice'
  map.check_in_existing_customer  '/check_in_existing_customer',  :controller => 'pages', :action => 'check_in_existing_customer'

  map.lock_screen  '/lock_screen',  :controller => 'pages', :action => 'lock_screen'
  map.unlock_screen  '/unlock_screen',  :controller => 'pages', :action => 'unlock_screen' 
  map.view_all_available_rooms  '/view_all_available_rooms',  :controller => 'pages', :action => 'view_all_available_rooms'
  map.view_all_occupied_rooms  '/view_all_occupied_rooms',  :controller => 'pages', :action => 'view_all_occupied_rooms'
  map.all_people_for_payments  '/all_people_for_payments',  :controller => 'pages', :action => 'all_people_for_payments'
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
