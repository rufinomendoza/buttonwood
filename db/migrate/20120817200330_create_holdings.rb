class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.integer :portfolio_id
      t.integer :security_id
      t.float :shares_held

      t.timestamps
    end
  end
end
