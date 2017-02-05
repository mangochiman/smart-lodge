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
      room_name = room.name
      room_rate = room.room_rates.last.rate rescue nil
      room_rate = number_to_currency(room_rate, :unit => 'MK') unless room_rate.blank?
      room_rate = 'N/A' if room_rate.blank?
      room_rates << [room_name, room_rate]
    end

    return room_rates
  end

  def available_users
    available_users = User.find(:all)
    return available_users
  end
  
end
