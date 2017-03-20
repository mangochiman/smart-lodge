class CreateBlackLists < ActiveRecord::Migration
  def self.up
    create_table :black_lists, :primary_key => :black_list_id do |t|
      t.integer :person_id
      t.date :value_date
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :black_lists
  end
end
