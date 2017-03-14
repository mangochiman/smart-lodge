class BookingPayment < ActiveRecord::Base
  set_table_name :booking_payments
  set_primary_key :booking_payment_id

  belongs_to :booking, :primary_key => :booking_id, :foreign_key => :booking_id
  default_scope :conditions => "#{self.table_name}.voided = 0"
end
