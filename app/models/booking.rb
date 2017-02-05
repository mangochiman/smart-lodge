class Booking < ActiveRecord::Base
  set_table_name :bookings
  set_primary_key :booking_id
  default_scope :conditions => "#{self.table_name}.voided = 0"
end
