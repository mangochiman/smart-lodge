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
    @room_types = RoomType.all.collect{|r|[r.room_type, r.room_type_id]}
  end

  def create_room
    room = Room.new
    room.number = params[:room_number]
    room.name = params[:room_name]
    room.room_type_id = params[:room_type]
    if room.save
      flash[:notice] = "You have successfully added a new room"
      redirect_to("/new_rooms_menu")
    else
      flash[:error] = room.errors.full_messages.join('<br />')
      redirect_to("/new_rooms_menu")
    end
  end

  def edit_rooms_menu
    @page_title = "Edit Rooms"
    @rooms = Room.find(:all)
  end

  def edit_room
    @room = Room.find(params[:room_id])
    @room_types = RoomType.all.collect{|r|[r.room_type, r.room_type_id]}
    @page_title = "Editing <i>#{@room.name}</i> details"
  end

  def update_room
    room = Room.find(params[:room_id])
    room.number = params[:room_number]
    room.name = params[:room_name]
    room.room_type_id = params[:room_type]
    
    if room.save
      flash[:notice] = "You have successfully updated room details"
      redirect_to("/edit_rooms_menu") and return
    else
      flash[:error] = room.errors.full_messages.join('<br />')
      redirect_to("/edit_rooms_menu")
    end
  end

  def view_rooms_menu
    @page_title = "View Rooms"
    @rooms = Room.find(:all)
    @rooms_data = {}
    @rooms.each do |room|
      room_type = room.room_type.room_type
      @rooms_data[room_type] = [] if @rooms_data[room_type].blank?
      @rooms_data[room_type] << room
    end
  end

  def remove_rooms_menu
    @page_title = "Remove Rooms"
    @rooms = Room.find(:all)
  end

  def remove_rooms
    room_ids = params[:room_ids].split(',')
    if room_ids.blank?
      flash[:error] = "Select item to delete"
      redirect_to("/remove_rooms_menu") and return
    end

    room_ids.each do |room_id|
      room = Room.find(room_id)
      room.voided = 1
      room.save
    end

    flash[:notice] = "You have succesfully deleted the selected rooms"
    redirect_to("/remove_rooms_menu") and return
  end
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  def new_rates_menu
    @page_title = "New Rates"
    @rooms = Room.find(:all)
    @today = Date.today.strftime("%d-%m-%Y")
  end

  def create_room_rates
    start_date = params[:start_date].to_date rescue nil
    end_date = params[:end_date].to_date rescue nil

    room_rate = RoomRate.new
    room_rate.room_id = params[:room_id]
    room_rate.rate = params[:rate]
    room_rate.start_date = start_date unless start_date.blank?
    room_rate.end_date = end_date unless end_date.blank?

    if room_rate.save
      flash[:notice] = "You have successfully added room rate"
      redirect_to("/new_rates_menu")
    else
      flash[:error] = room_rate.errors.full_messages.join('<br />')
      redirect_to("/new_rates_menu")
    end
  end

  def edit_rates_menu
    @page_title = "Edit Rates"
    @room_rates = RoomRate.find(:all)
  end

  def edit_room_rate
    @room_rate = RoomRate.find(params[:room_rate_id])
    @start_date = @room_rate.start_date.strftime("%d-%m-%Y") rescue Date.today.strftime("%d-%m-%Y")
    @end_date = @room_rate.end_date.strftime("%d-%m-%Y") rescue ""
    @rooms = Room.find(:all)
    @page_title = "Editing rates of <i>#{@room_rate.room.name}</i>"
  end

  def update_room_rates
    start_date = params[:start_date].to_date rescue nil
    end_date = params[:end_date].to_date rescue nil

    room_rate = RoomRate.find(params[:room_rate_id])
    room_rate.room_id = params[:room_id]
    room_rate.rate = params[:rate]
    room_rate.start_date = start_date unless start_date.blank?
    room_rate.end_date = end_date unless end_date.blank?

    if room_rate.save
      flash[:notice] = "You have successfully updated room rate"
      redirect_to("/edit_room_rate/#{params[:room_rate_id]}")
    else
      flash[:error] = room_rate.errors.full_messages.join('<br />')
      redirect_to("/edit_room_rate/#{params[:room_rate_id]}")
    end
  end
  
  def view_rates_menu
    @page_title = "View Rates"

    rooms_rates = RoomRate.find(:all)
    @room_rates_data = {}
    rooms_rates.each do |room_rate|
      room_type = room_rate.room.room_type.room_type
      @room_rates_data[room_type] = [] if @room_rates_data[room_type].blank?
      @room_rates_data[room_type] << room_rate
    end
  end

  def remove_rates_menu
    @page_title = "Remove Rates"
    @room_rates = RoomRate.find(:all)
  end

  def remove_rates
    room_rate_ids = params[:room_rate_ids].split(',')
    if room_rate_ids.blank?
      flash[:error] = "Select item to delete"
      redirect_to("/remove_rates_menu") and return
    end

    room_rate_ids.each do |room_rate_id|
      room_rate = RoomRate.find(room_rate_id)
      room_rate.voided = 1
      room_rate.save
    end

    flash[:notice] = "You have succesfully deleted room rates"
    redirect_to("/remove_rates_menu") and return
  end
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  def new_users_menu
    @page_title = "New Users"
    @roles = [["Admin", "admin"], ["Receptionist", "receptionist"]]
  end

  def create
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    phone_number = params[:phone_number]
    username = params[:username]
    password = params[:password]
    password_confirm = params[:confirm_password]

    if (password != password_confirm)
      flash[:error] = "Password Mismatch"
      redirect_to("/new_users_menu") and return
    end
    salt = User.random_string(10)

    user = User.new
    user.first_name = first_name
    user.last_name = last_name
    user.email = email
    user.phone_number = phone_number
    user.salt = salt
    user.password = User.encrypt(password, salt)
    user. username = username

    if user.save
      user_role = UserRole.new
      user_role.username = user.username
      user_role.role = params[:user_role]
      user_role.save
      flash[:notice] = "You have successfully created an account."
      redirect_to("/new_users_menu") and return
    else
      flash[:error] = user.errors.full_messages.join('<br />')
      redirect_to("/new_users_menu") and return
    end
  end

  def edit_users_menu
    @page_title = "Edit Users"
  end

  def edit_user
    @user = User.find(params[:user_id])
    @user_role = @user.role.downcase
    @roles = [["Admin", "admin"], ["Receptionist", "receptionist"]]
    @page_title = "Editing #{@user.username}"
  end

  def update_account_by_admin
    @user = User.find(params[:user_id])
    if @user.update_attributes({
          :first_name => params[:first_name],
          :last_name => params[:last_name],
          :phone_number => params[:phone_number],
          :email => params[:email]
        })

      ActiveRecord::Base.transaction do
        user_roles = UserRole.find(:all, :conditions => ["username = ?", @user.username])
        user_roles.each do |user_role|
          user_role.delete
        end

        new_user_role = UserRole.new
        new_user_role.username = @user.username
        new_user_role.role = params[:user_role]
        new_user_role.save
      end

      flash[:notice] = "You have successfully edited <b>#{@user.username}'s </b> account"
      redirect_to("/view_users_menu") and return
    else
      flash[:error] = "Failed to update the account <b>#{@user.username}</b>"
      redirect_to("/view_users_menu") and return
    end
  end
  
  def view_users_menu
    @page_title = "View Users"
    @users = User.find(:all, :conditions => ["user_id != ?", session[:user].user_id])
  end

  def remove_users_menu
    @page_title = "Remove Users"
  end
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

end
