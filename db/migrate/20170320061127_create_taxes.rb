class CreateTaxes < ActiveRecord::Migration
  def self.up
    create_table :taxes, :primary_key => :tax_id do |t|
      t.string :name
      t.float :value
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :taxes
  end
end
