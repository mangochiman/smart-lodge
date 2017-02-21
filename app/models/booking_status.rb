class BookingStatus < ActiveRecord::Base
  set_table_name :booking_statuses
  set_primary_key :booking_status_id

  belongs_to :booking, :foreign_key => :booking_id, :primary_key => :booking_id
  default_scope :conditions => "#{self.table_name}.voided = 0"
end
