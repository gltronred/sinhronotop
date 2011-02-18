class AddCityParams < ActiveRecord::Migration
  def self.up
    add_column :cities, :province, :string
    add_column :cities, :country, :string    
    add_column :cities, :time_shift, :integer
    add_column :cities, :time_zone, :string
    add_column :cities, :rating_id, :integer
  end

  def self.down
    remove_column :cities, :province
    remove_column :cities, :country
    remove_column :cities, :time_shift
    remove_column :cities, :time_zone
    remove_column :cities, :rating_id
  end
end
