class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.integer :user_id
      t.string :our_sector
      t.string :symbol
      t.float :our_price_target
      t.float :our_current_year_eps
      t.float :our_next_year_eps

      t.timestamps
    end
  end
end
