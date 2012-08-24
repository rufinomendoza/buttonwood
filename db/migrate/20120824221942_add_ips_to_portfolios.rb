class AddIpsToPortfolios < ActiveRecord::Migration
  def change
    add_column :portfolios, :ips, :text
  end
end
