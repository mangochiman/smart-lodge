class Booking < ActiveRecord::Base
  set_table_name :bookings
  set_primary_key :booking_id

  belongs_to :person, :primary_key => "person_id", :foreign_key => "person_id"
  belongs_to :room_booking, :primary_key => "booking_id", :foreign_key => "booking_id"
  default_scope :conditions => "#{self.table_name}.voided = 0"
end
