class AdminController < ApplicationController
  layout 'admin'
  
  def dashboard
    @page_title = "Admin Dashboard"
  end
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  def new_room_type_menu
    @page_title = "New Room Type"
  end

  def edit_room_types_menu
    @page_title = "Edit Room Types"
  end

  def view_room_types_menu
    @page_title = "View Room Types"
  end

  def remove_room_types_menu
    @page_title = "Remove Room Types"
  end
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  def new_rooms_menu
    @page_title = "New Rooms"
  end

  def edit_rooms_menu
    @page_title = "Edit Rooms"
  end

  def view_rooms_menu
    @page_title = "View Rooms"
  end

  def remove_rooms_menu
    @page_title = "Remove Rooms"
  end
  
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  def new_rates_menu
    @page_title = "New Rates"
  end

  def edit_rates_menu
    @page_title = "Edit Rates"
  end

  def view_rates_menu
    @page_title = "View Rates"
  end

  def remove_rates_menu
    @page_title = "Remove Rates"
  end
  
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  def new_users_menu
    @page_title = "New Users"
  end

  def edit_users_menu
    @page_title = "Edit Users"
  end

  def view_users_menu
    @page_title = "View Users"
  end

  def remove_users_menu
    @page_title = "Remove Users"
  end
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

end
