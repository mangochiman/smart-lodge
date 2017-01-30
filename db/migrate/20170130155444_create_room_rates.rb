class CreateRoomRates < ActiveRecord::Migration
  def self.up
    create_table :room_rates do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :room_rates
  end
end
