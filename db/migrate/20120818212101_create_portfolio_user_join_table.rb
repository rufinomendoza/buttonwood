class CreatePortfolioUserJoinTable < ActiveRecord::Migration
  def change
    create_table :portfolios_users, :id => false do |t|
      t.integer :portfolio_id
      t.integer :user_id
    end
  end
end
