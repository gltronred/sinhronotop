class AddIpTracking < ActiveRecord::Migration
  def self.up
    add_column :events, :ips, :string
  end

  def self.down
    remove_column :events, :ips
  end
end
