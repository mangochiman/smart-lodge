class CreateBillableItems < ActiveRecord::Migration
  def self.up
    create_table :billable_items, :primary_key => :billable_item_id do |t|
      t.integer :booking_id
      t.string :item
      t.float :price
      t.integer :quantity
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :billable_items
  end
end
