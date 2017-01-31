class Booking < ActiveRecord::Base
  set_table_name :bookings
  set_primary_key :booking_id
  default_scope :conditions => "voided = 0"
end
