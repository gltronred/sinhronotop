class AddLongtext < ActiveRecord::Migration
  def self.up
    create_table :longtexts do |t|
      t.string :title
      t.string :value, :limit => 20000
      t.boolean :new_page
      t.integer :game_id
      t.integer :tournament_id
      t.timestamps
    end
  end

  def self.down
    drop_table :longtexts
  end
end
