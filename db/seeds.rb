
def default_data
  create_user()
  create_people()
  create_room_types()
  create_rooms()
  create_bookings()
  create_room_rates()
end

def create_user
  salt = User.random_string(10)
  user = User.new
  user.first_name = 'Ernest'
  user.last_name = 'Matola'
  user.email = 'mangochiman@gmail.com'
  user.phone_number = '+265999607901'
  user.username = 'mangochiman'
  user.password = User.encrypt('mangochiman', salt)
  user.salt = salt
  user.save
end

def create_people
  people = {
    1 => {:first_name => "Mary", :last_name => "Banda", :gender => "Female", :email => "mary@gmail.com", :title=> "Mrs", :phone_number=> "0989877", :address=> "Box 234, LL"},
    2 => {:first_name => "Maria", :last_name => "Chisale", :gender => "Female", :email => "maria@gmail.com", :title=> "Mrs", :phone_number=> "099898987", :address=> "Box 224, BT"},
    3 => {:first_name => "Mphatso", :last_name => "Bwerani", :gender => "Male", :email => "mphatso@gmail.com", :title=> "Mr", :phone_number=> "0878733", :address=> "Box 200, LL"},
    4 => {:first_name => "John", :last_name => "Chisamba", :gender => "Male", :email => "jo@gmail.com", :title=> "Mr", :phone_number=> "077333", :address=> "Box 676, LL"},
    5 => {:first_name => "Elliot", :last_name => "Elo", :gender => "Male", :email => "elli@gmail.com", :title=> "Dr", :phone_number=> "033332233", :address=> "Box 123, LL"},
    6 => {:first_name => "Kondwani", :last_name => "Selemani", :gender => "Male", :email => "kho@gmail.com", :title=> "Dr", :phone_number=> "09899877", :address=> "Box 23894, LL"},
    7 => {:first_name => "Steve", :last_name => "Chima", :gender => "Male", :email => "steve@gmail.com", :title=> "Mr", :phone_number=> "098339877", :address=> "Box 23994, LL"},
    8 => {:first_name => "Adrian", :last_name => "Chaipa", :gender => "Male", :email => "adrian@gmail.com", :title=> "Mr", :phone_number=> "09689877", :address=> "Box 23664, LL"},
    9 => {:first_name => "George", :last_name => "Mhango", :gender => "Male", :email => "geo@gmail.com", :title=> "Mr", :phone_number=> "09898774", :address=> "Box 23224, LL"},
    10 => {:first_name => "Rodgers", :last_name => "Phiri", :gender => "Male", :email => "rodgers@gmail.com", :title=> "Mr", :phone_number=> "098987447", :address=> "Box 1234, LL"}
  }

  people.each do |number, person_details|
    person = Person.new(person_details)
    person.save
  end
  
end

def create_room_types
  room_types = {
    1 => {:max_capacity => 2, :room_type => "Standard"},
    2 => {:max_capacity => 4, :room_type => "Family"},
    3 => {:max_capacity => 3, :room_type => "Special"},
    4 => {:max_capacity => 3, :room_type => "VIP"}
  }
  room_types.each do |number, room_type_details|
    room_type = RoomType.new(room_type_details)
    room_type.save
  end
end

def create_rooms
  room_type_ids = RoomType.all.map(&:room_type_id)
  room_names = ["Room One", "Room Two", "Room Four", "Room Four", "Room Five", "Room Six", "Room Seven", "Room Eight", "Room Nine", "Room Ten"]
  count = 1
  room_names.each do |room_name|
    room_type_id = room_type_ids.shuffle.first
    room = Room.new
    room.name = room_name
    room.room_type_id = room_type_id
    room.number = count
    room.save
    count = count + 1
  end
end

def create_bookings
  people = Person.all
  booking_dates = [["01-Feb-2017", "01-Feb-2017"], ["01-Jan-2017", "06-Jan-2017"], ["20-Feb-2017", "25-Feb-2017"]]
  room_ids = Room.all.map(&:room_id)
  people.each do |person|
    dates = booking_dates.shuffle.first
    room_id = room_ids.shuffle.first

    booking = Booking.new
    booking.person_id = person.person_id
    booking.start_date = dates[0].to_date
    booking.end_date = dates[1].to_date
    booking.save

    room_booking = RoomBooking.new
    room_booking.booking_id = booking.booking_id
    room_booking.room_id = room_id
    room_booking.save

    booking_status = BookingStatus.new
    booking_status.booking_id = booking.booking_id
    booking_status.status = 'checkin'
    booking_status.status_date = Date.today
    booking_status.save
  end
end

def create_room_rates
  rooms = Room.all
  rates = ["15000", "20000", "30000", "40000", "50000"]
  rooms.each do |room|
    rate = rates.shuffle.first
    room_rate = RoomRate.new
    room_rate.room_id = room.room_id
    room_rate.rate = rate
    room_rate.start_date = Date.today
    room_rate.save
  end
end

default_data