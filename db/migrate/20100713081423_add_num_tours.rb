class AddNumTours < ActiveRecord::Migration
  def self.up
    add_column :games, :num_tours, :integer
  end

  def self.down
    remove_column :games, :num_tours
  end
end
