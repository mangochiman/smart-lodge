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
end
