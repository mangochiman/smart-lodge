# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in_user_details
    user = User.find(session[:user].user_id)
    user_names = user.first_name + ' ' + user.last_name
    return user_names
  end

  def room_types
    room_types = RoomType.find(:all)
    return room_types
  end

  def room_rates
    rooms = Room.find(:all)
    room_rates = []
    
    rooms.each do |room|
      room_rate = room.room_rates.last
      room_rates << [room, room_rate]
    end

    return room_rates
  end

  def available_users
    available_users = User.find(:all)
    return available_users
  end

  def available_rooms
    rooms = Room.find(:all)
    return rooms
  end

  def settings
    settings = YAML.load(File.read(Rails.root.to_s + "/config/settings.yml"))
    return settings
  end
  
end
