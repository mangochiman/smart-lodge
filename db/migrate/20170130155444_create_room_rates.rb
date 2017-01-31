class CreateRoomRates < ActiveRecord::Migration
  def self.up
    create_table :room_rates, :primary_key => :room_rate_id do |t|
      t.integer :room_id
      t.integer :rate
      t.date :start_date
      t.date :end_date
      t.integer :creator
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :room_rates
  end
end
