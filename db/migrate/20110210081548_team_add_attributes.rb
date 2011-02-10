class TeamAddAttributes < ActiveRecord::Migration
  def self.up
    add_column :teams, :rating_id, :integer
    add_column :teams, :city_id, :integer
    add_index :teams, :rating_id
  end

  def self.down
    remove_column :teams, :rating_id
    remove_column :teams, :city_id
    remove_index :teams, :rating_id
  end
end
