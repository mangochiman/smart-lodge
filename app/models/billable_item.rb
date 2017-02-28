class BillableItem < ActiveRecord::Base
  set_table_name :billable_items
  set_primary_key :billable_item_id

  belongs_to :booking, :primary_key => :booking_id, :foreign_key => :booking_id
  default_scope :conditions => "#{self.table_name}.voided = 0"
end
