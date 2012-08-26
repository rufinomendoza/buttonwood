class AddSectorIdToSecurity < ActiveRecord::Migration
  def change
    add_column :securities, :sector_id, :integer
  end
end
