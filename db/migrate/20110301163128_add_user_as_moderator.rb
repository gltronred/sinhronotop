class AddUserAsModerator < ActiveRecord::Migration
  def self.up
    add_column :events, :moderation_id, :integer
  end

  def self.down
    remove_column :events, :moderation_id
  end
end
