class RoomType < ActiveRecord::Base
  set_table_name :room_types
  set_primary_key :room_type_id
  default_scope :conditions => "#{self.table_name}.voided = 0"

  has_many :rooms, :foreign_key => :room_type_id
end
