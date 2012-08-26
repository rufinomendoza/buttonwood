class RemoveOurSectorFromSecurity < ActiveRecord::Migration
  def up
    remove_column :securities, :our_sector
  end

  def down
    add_column :securities, :our_sector, :string
  end
end
