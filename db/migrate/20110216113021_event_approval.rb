class EventApproval < ActiveRecord::Migration
  def self.up
    create_table "event_statuses", :force => true do |t|
      t.string :short_name
      t.string :name
    end
    add_column :events, :event_status_id, :integer
  end

  def self.down
    drop_table "event_statuses"
    remove_column :events, :event_status_id
  end
end
