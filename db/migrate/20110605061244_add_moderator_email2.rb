class AddModeratorEmail2 < ActiveRecord::Migration
  def self.up
    add_column :events, :moderator_email2, :string
  end

  def self.down
    remove_column :events, :moderator_email2
  end
end
