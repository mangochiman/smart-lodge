class Room < ActiveRecord::Base
  set_table_name :rooms
  set_primary_key :room_id

  belongs_to :room_type, :primary_key => :room_type_id
  has_many :room_rates, :foreign_key => :room_id

  default_scope :conditions => "voided = 0"
end
