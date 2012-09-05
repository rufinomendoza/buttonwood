class DropPortfoliosUsers < ActiveRecord::Migration
  def up
    drop_table :portfolios_users
  end

  def down
    create_table :portfolios_users, :id => false do |t|
      t.integer :portfolio_id
      t.integer :user_id
    end
  end
end
