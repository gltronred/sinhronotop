class AddLinkText < ActiveRecord::Migration
  def self.up
    add_column :links, :text, :string
  end

  def self.down
    remove_column :links, :text
  end
end
