class AdminController < ApplicationController
  layout 'admin'
  
  def dashboard
    @page_title = "Admin Dashboard"
  end
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  def new_room_type_menu
    @page_title = "New Room Type"
    @room_types = RoomType.all
  end

  def edit_room_types_menu
    @page_title = "Edit Room Types"
  end

  def edit_room_type
    @page_title = "Editing Room Types"
    @room_types = RoomType.all
    @room_type = RoomType.find(params[:room_type_id])
  end

  def create_room_type
    room_type = RoomType.new
    room_type.room_type = params[:room_type]
    room_type.max_capacity = params[:max_capacity]
    if room_type.save
      flash[:notice] = "You have successfully added a new room type"
      redirect_to("/new_room_type_menu")
    else
      flash[:error] = room_type.errors.full_messages.join('<br />')
      redirect_to("/new_room_type_menu")
    end
  end

  def update_room_type
    room_type = RoomType.find(params[:room_type_id])
    room_type.room_type = params[:room_type]
    room_type.max_capacity = params[:max_capacity]

    if room_type.save
      flash[:notice] = "You have successfully updated room type"
      redirect_to("/edit_room_type/#{params[:room_type_id]}") and return
    else
      flash[:error] = faculty.errors.full_messages.join('<br />')
      redirect_to("/edit_room_type/#{params[:room_type_id]}") and return
    end
  end

  def view_room_types_menu
    @page_title = "View Room Types"
    @room_types = RoomType.all
  end

  def remove_room_types_menu
    @page_title = "Remove Room Types"
    @room_types = RoomType.all
  end

  def remove_room_types
    room_type_ids = params[:room_type_ids].split(',')
    if room_type_ids.blank?
      flash[:error] = "Select item to delete"
      redirect_to("/remove_room_types_menu") and return
    end

    room_type_ids.each do |room_type_id|
      room_type = RoomType.find(room_type_id)
      room_type.voided = 1
      room_type.save
    end

    flash[:notice] = "You have succesfully deleted room type"
    redirect_to("/remove_room_types_menu") and return
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
