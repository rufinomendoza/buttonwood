class AddOtherIndices < ActiveRecord::Migration
  def change
    add_index :portfolios, :user_id
    add_index :sectors, :user_id
    add_index :securities, :user_id
    add_index :securities, :symbol
  end
end
