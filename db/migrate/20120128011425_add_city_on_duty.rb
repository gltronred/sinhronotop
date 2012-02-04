class AddCityOnDuty < ActiveRecord::Migration
  def self.up
    add_column :games, :city_id, :integer
  end
 
  def self.down
    remove_column :games, :city_id
  end
end
