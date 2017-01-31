class RoomRate < ActiveRecord::Base
  set_table_name :room_rates
  set_primary_key :room_rate_id
  default_scope :conditions => "voided = 0"
end
