class AddTags < ActiveRecord::Migration
  def self.up
    create_table "tags", :force => true do |t|
      t.string :short_name
      t.string :name
    end
    add_column :results, :tag_id, :integer
    create_table "tags_tournaments", :id => false, :force => true do |t|
      t.integer "tag_id"
      t.integer "tournament_id"
    end
  end

  def self.down
    drop_table "tags"
    remove_column :results, :tag_id
    drop_table "tags_tournaments"
  end
end
