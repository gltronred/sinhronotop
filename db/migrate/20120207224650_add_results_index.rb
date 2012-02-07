class AddResultsIndex < ActiveRecord::Migration
  def self.up
    add_index :results, :event_id
  end

  def self.down
    remove_index :results, :event_id
  end
end
