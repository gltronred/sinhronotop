class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :firstName
      t.string :lastName
      t.string :patronymic

      t.integer :team_id
      t.integer :rating_id

      t.timestamps
  end

  def self.down
    drop_table :players
  end
  end
end
