class AddLastChangeForEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :last_change, :string
  end

  def self.down
    remove_column :events, :last_change
  end
end
