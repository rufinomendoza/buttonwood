class AddIndexToHoldings < ActiveRecord::Migration
  def change
    add_index :holdings, :portfolio_id
    add_index :holdings, :security_id
  end
end
