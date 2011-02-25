class ChangeLimOfAppeal < ActiveRecord::Migration
  def self.up
    remove_column :appeals, :argument
    add_column :appeals, :argument, :string, :limit => 20000
  end

  def self.down
    remove_column :appeals, :argument
    add_column :appeals, :argument, :string
  end
end
